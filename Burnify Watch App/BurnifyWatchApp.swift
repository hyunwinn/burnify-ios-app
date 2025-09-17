//
//  BurnifyApp.swift
//  Burnify Watch App
//
//  Created by 조현승 on 11/08/2025.
//

import SwiftUI

@main
struct BurnifyWatchApp: App {
    @State private var workoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSumamryView) {
                SummaryView()
            }
            .environment(workoutManager)
        }
    }
}
