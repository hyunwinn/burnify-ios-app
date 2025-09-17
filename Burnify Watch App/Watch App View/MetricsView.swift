//
//  MetricsView.swift
//  Burnify Watch App
//
//  Created by 조현승 on 27/08/2025.
//

import SwiftUI

struct MetricsView: View {
    @Environment(WorkoutManager.self) var workoutManager
    
    var body: some View {
        VStack(alignment: .leading) {
            ElapsedTimeView(
                elapsedTime:
                    workoutManager.builder?.elapsedTime ?? 0,
                showCentiseconds: true
            ).foregroundColor(Color.yellow)
            Text(
                Measurement(
                    value: workoutManager.activeEnergy,
                    unit: UnitEnergy.kilocalories
                ).formatted(
                    .measurement(
                        width: .abbreviated,
                        usage:.workout,
                        numberFormatStyle: .number.precision(.fractionLength(0))
                    )
                )
            )
            Text(
                workoutManager.heartRate
                    .formatted(
                    .number.precision(.fractionLength(0))
                )
            + " bpm"
            )
            Text(
                Measurement(
                    value: workoutManager.distance,
                    unit: UnitLength.meters
                ).formatted(
                    .measurement(
                        width: .abbreviated,
                        usage: .road
                    )
                )
            )
        }
        .font(.system(.title, design: .rounded)
            .monospacedDigit()
            .lowercaseSmallCaps()
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea(edges: .bottom)
        .scenePadding()
    }
}

#Preview {
    MetricsView()
        .environment(WorkoutManager())
}
