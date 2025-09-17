//
//  HKWorkoutActivityType.swift
//  Burnify
//
//  Created by 조현승 on 27/08/2025.
//

import SwiftUI
import HealthKit

extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .cycling:
            return "사이클링"
        case .swimming:
            return "수영"
        case .walking:
            return "걷기"
        case .running:
            return "달리기"
        case .stairClimbing:
            return "스텝밀"
        case .jumpRope:
            return "줄넘기"
        default:
            return ""
        }
    }
    
    var symbol: Image { Image(systemName: symbolName) }
    
    var symbolName: String {
        switch self {
        case .cycling:
            return "figure.outdoor.cycle"
        case .swimming:
            return "figure.pool.swim"
        case .walking:
            return "figure.walk"
        case .running:
            return "figure.run"
        case .stairClimbing:
            return "figure.stair.stepper"
        case .jumpRope:
            return "figure.jumprope"
        default:
            return ""
        }
    }
    
}
