//
//  ElaspedTimeView.swift
//  Burnify Watch App
//
//  Created by 조현승 on 28/08/2025.
//
// planning to add aod feature

import SwiftUI

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showCentiseconds: Bool = true
    
    var body: some View {
        Text(elapsedTime.formatted(.elapsed(showCentiseconds: showCentiseconds)))
            .monospacedDigit()
            .fontWeight(.semibold)
    }
}

struct ElapsedTimeFormatStyle: FormatStyle {
    typealias FormatInput = TimeInterval
    typealias FormatOutput = String
    
    var showCS: Bool = true
    
    func format(_ value: TimeInterval) -> String {
        let formattedString = Duration.seconds(value)
            .formatted(.time(pattern: .minuteSecond(padMinuteToLength: 2)))
        
        guard showCS else { return formattedString }
        
        let totalCentiseconds = Int((value * 100).rounded(.towardZero))
        let cs = totalCentiseconds % 100
        
        return formattedString + String(format: ".%02d", cs)
    }
}

extension FormatStyle where Self == ElapsedTimeFormatStyle {
    static func elapsed(showCentiseconds: Bool) -> ElapsedTimeFormatStyle {
            ElapsedTimeFormatStyle(showCS: showCentiseconds)
    }
}

#Preview {
    ElapsedTimeView()
}
