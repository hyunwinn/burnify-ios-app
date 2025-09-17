//
//  SummaryView.swift
//  Burnify Watch App
//
//  Created by 조현승 on 01/09/2025.
//

import SwiftUI
import HealthKit

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss
    let timeStyle = Duration.TimeFormatStyle(pattern: .hourMinuteSecond(padHourToLength: 2))
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                SummaryMetricView(
                    title: "시간",
                    value: Duration.seconds(30 * 60 + 15).formatted(timeStyle)
                ).accentColor(Color.yellow)
                SummaryMetricView(
                    title: "거리",
                    value: Measurement(
                        value: 1625,
                        unit: UnitLength.meters
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .road
                        )
                    )
                ).accentColor(Color.green)
                SummaryMetricView(
                    title: "칼로리",
                    value: Measurement(
                        value: 96,
                        unit: UnitEnergy.kilocalories
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout,
                            numberFormatStyle: .number.precision(.fractionLength(0))
                        )
                    )
                ).accentColor(Color.pink)
                SummaryMetricView(
                    title: "평균 심박수",
                    value: 143
                        .formatted(
                            .number.precision(
                                .fractionLength(0)
                            )
                        )
                    + " bpm"
                ).accentColor(Color.red)
                ActivityRingsView(healthStore: HKHealthStore())
                    .frame(width: 50, height: 50)
                Button("완료"){
                    dismiss()
                }
            }
            .scenePadding()
        }
        .navigationTitle("운동 요약")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SummaryView()
}

struct SummaryMetricView: View {
    var title: String
    var value: String
    
    var body: some View {
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                .lowercaseSmallCaps()
            )
            .foregroundColor(.accentColor)
        Divider()
    }
}
