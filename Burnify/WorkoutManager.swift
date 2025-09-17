//
//  WorkoutManager.swift
//  Burnify
//
//  Created by 조현승 on 11/08/2025.
//

import Foundation
import HealthKit
import Observation

@Observable
@MainActor
class WorkoutManager: NSObject {
    
    struct SessionStateChange {
        let newState: HKWorkoutSessionState
        let date: Date
    }
    
    private(set) var state: HKWorkoutSessionState = .notStarted
    
    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout else { return }
            Task {
                do {
                    try await prepareWorkout(workoutType: selectedWorkout)
                    //try await DispatchQueue.main.sleep(for: .seconds(3))
                    startWorkout()
                } catch {
                    ErrorReporter.notPrepared.log(error)
                    state = .notStarted
                }
            }
        }
    }
    
    var showingSumamryView: Bool = false {
        didSet {
            if showingSumamryView == false {
                selectedWorkout = nil
            }
        }
    }

    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    /**
    AsyncStream for serializing HKWorkoutSession state changes.
     - Delegate can fire rapid, multi-threaded events; we funnel them into a single, ordered consumer.
     - bufferingNewest(1): keep only the latest state to avoid backlog.
     - A single for-await loop consumes these events and runs cleanup only when state == .stopped.
     */
    let asyncStreamTuple = AsyncStream.makeStream(of: SessionStateChange.self, bufferingPolicy: .bufferingNewest(1))
    
    override init() {
        super.init()
        Task {
            for await value in asyncStreamTuple.stream {
                await consumeSessionStateChange(value)
            }
        }
    }
    
    // MARK: - Request HealthKit authorization.
    
    var isAuthorised = false
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            ErrorReporter.deviceNotSupported.log()
            return
        }
        
        let toShare: Set<HKSampleType> = [HKObjectType.workoutType()]
        let toRead: Set<HKObjectType> = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType()
        ]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: toShare, read: toRead)
            } catch {
                ErrorReporter.authorizationFailed.log(error)
            }
        }
    }
    
    // MARK: - Workout functions
    
    func prepareWorkout(workoutType: HKWorkoutActivityType) async throws {
        // Create workout configuration
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        builder = session?.associatedWorkoutBuilder()
        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        
        session?.prepare()
        state = .prepared
    }
    
    func startWorkout() {
        Task {
            do {
                let startDate = Date()
                session?.startActivity(with: startDate)
                state = .running
                try await builder?.beginCollection(at: startDate)
            } catch {
                ErrorReporter.startFailed.log(error)
                state = .notStarted
            }
        }
    }
    
    // MARK: - State Control
    
    func pause() {
        session?.pause()
    }
    
    func resume() {
        session?.resume()
    }
    
    func togglePause() {
        switch state {
        case .running:
            pause()
        case .paused:
            resume()
        default:
            ErrorReporter.invalidCall.log()
        }
    }
    
    func endWorkout() {
        state = .stopped
        session?.stopActivity(with: .now)
        showingSumamryView = true
    }
    
    // MARK: - Workout Metrics
    
    var averageHeartRate: Double = 0
    var heartRate: Double = 0
    var activeEnergy: Double = 0
    var distance: Double = 0
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        Task {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
                HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let distanceUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: distanceUnit) ?? 0
            default:
                return
            }
        }
    }
    
    // MARK: - Private functions
    
    private func consumeSessionStateChange(_ change :SessionStateChange) async {
        guard change.newState == .stopped, let builder else { return }
        
        do {
            try await builder.endCollection(at: change.date)
            try await builder.finishWorkout()
            session?.end()
            state = .ended
        } catch {
            ErrorReporter.endFailed.log(error)
        }
    }
    /*
    // Reset resources if start workout fails
    private func resetOnStartWorkoutError() async {
        if let session = self.session {
            session.stopActivity(with: Date())
            session.end()
        }
        
        if let builder = self.builder {
            await withCheckedContinuation { continuation in
                builder.endCollection(withEnd: Date()) {
                    _,_ in continuation.resume()
                }
            }
            self.session = nil
            self.builder = nil
        }
    }
    
     private func resetWorkoutState() {
         isWorkoutActive = false
         currentHeartRate = 0
         workoutSession = nil
         workoutBuilder = nil
         print("Workout stopped and reset")
     }
     */
}

// MARK: - Delegates

extension WorkoutManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        Task {
            await MainActor.run {
                switch toState {
                case .running:
                    self.state = .running
                case .paused:
                    self.state = .paused
                default:
                    break
                }
            }
        }
        
        let change = SessionStateChange(newState: toState, date: date)
        asyncStreamTuple.continuation.yield(change)
    }
    
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                        didFailWithError error: any Error) {
        ErrorReporter.didFailWithError.log(error)
    }
    
    nonisolated func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder,
                        didCollectDataOf collectedTypes: Set<HKSampleType>) {
        Task { @MainActor in
            for type in collectedTypes {
                guard let quantityType = type as? HKQuantityType else { return }
                
                let statistics = workoutBuilder.statistics(for: quantityType)
                
                // updateForStatistics(statistics)
            }
        }
    }
    
    nonisolated func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
    
    
}
