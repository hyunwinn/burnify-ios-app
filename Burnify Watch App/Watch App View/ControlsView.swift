//
//  ControlsView.swift
//  Burnify Watch App
//
//  Created by 조현승 on 28/08/2025.
//

import SwiftUI

struct ControlsView: View {
    @Environment(WorkoutManager.self) var workoutManager
    
    var body: some View {
        HStack {
            VStack {
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonBorderShape(.roundedRectangle(radius: 15))
                .tint(Color.red)
                .font(.title2)
                Text("길게 눌러 종료")
                .foregroundColor(Color.red)
            }
            VStack {
                Button {
                    workoutManager.togglePause()
                } label: {
                    Image(systemName: workoutManager.state == .running ? "pause.fill" : "arrow.clockwise")
                }
                .buttonBorderShape(.roundedRectangle(radius: 15))
                .tint(Color.yellow)
                .font(.title2)
                Text(workoutManager.state == .running ? "일시 정지" : "재개")
                .foregroundColor(Color.yellow)
            }
        }
    }
}

#Preview {
    ControlsView()
        .environment(WorkoutManager())
}
