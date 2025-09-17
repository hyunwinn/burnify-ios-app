//
//  ContentView.swift
//  Burnify Watch App
//
//  Created by 조현승 on 11/08/2025.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @Environment(WorkoutManager.self) var workoutManager
    let workoutTypes: [HKWorkoutActivityType] = [.cycling, .swimming, .walking, .running, .stairClimbing, .jumpRope]

    
    var body: some View {
        NavigationStack {
            List(workoutTypes, id: \.rawValue) { workoutType in
                NavigationLink(value: workoutType) {
                    StartRowView(workoutType: workoutType)
                }
            }
            .navigationBarTitle("운동 시작")
            .navigationDestination(for: HKWorkoutActivityType.self) { workoutType in
                SessionView()
                    .onAppear {
                        workoutManager.selectedWorkout = workoutType
                    }
            }
        }
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

#Preview {
    StartView()
        .environment(WorkoutManager())
}

private struct StartRowView: View {
    let workoutType: HKWorkoutActivityType
    
    var body: some View {
        HStack(spacing: 0) {
            workoutType.symbol
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 18))
                .frame(width: 22, alignment: .leading)
            
            Text(workoutType.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 12)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 8)
    }
}
    
