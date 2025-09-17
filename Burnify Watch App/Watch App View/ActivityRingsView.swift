//
//  ActivityRingsView.swift
//  Burnify Watch App
//
//  Created by 조현승 on 02/09/2025.
//

import Foundation
import HealthKit
import SwiftUI

struct ActivityRingsView: WKInterfaceObjectRepresentable {
    let healthStore: HKHealthStore
    
    func makeWKInterfaceObject(context: Context) -> some WKInterfaceObject {
        let activityRingsObeject = WKInterfaceActivityRing()
        
        Task {
            if let summary = try? await fetchActivitySummary() {
                await MainActor.run {
                    activityRingsObeject.setActivitySummary(summary, animated: true)
                }
            }
        }
        return activityRingsObeject
    }
    
    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceObjectType, context: Context) {
        
    }
    
    private func getPredicate() -> NSPredicate {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day], from: Date())
        components.calendar = calendar
        
        return HKQuery.predicateForActivitySummary(with: components)
    }
    
    private func fetchActivitySummary() async throws -> HKActivitySummary? {
        try await withCheckedThrowingContinuation{ continuation in
            let query = HKActivitySummaryQuery(predicate: getPredicate()) { _, summaries, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: summaries?.first)
                }
            }
            healthStore.execute(query)
        }
    }
}
