//
//  SessionView.swift
//  Burnify Watch App
//
//  Created by 조현승 on 27/08/2025.
//

import SwiftUI
import WatchKit

struct SessionView: View {
    @Environment(WorkoutManager.self) var workoutManager
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controls, metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)
        }
        .navigationTitle(workoutManager.selectedWorkout?.name ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .nowPlaying)
        .onChange(of: workoutManager.state) { oldState, newState in
            if oldState != .running && newState == .running {
                displayMetricsView()
            }
        }
    }
    
    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }
}

#Preview {
    SessionView()
        .environment(WorkoutManager())
}
