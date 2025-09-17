//
//  ErrorReporter.swift
//  Burnify
//
//  Created by 조현승 on 10/09/2025.
//

import Foundation
import Swift

enum ErrorReporter: CustomStringConvertible {
    case deviceNotSupported
    case authorizationFailed
    case notPrepared
    case startFailed
    case endFailed
    case didFailWithError
    case invalidCall
    
    var description: String {
        switch self {
                case .deviceNotSupported:   return "Device not supported"
                case .authorizationFailed:  return "Failed to request Authorization"
                case .notPrepared:          return "Workout not prepared"
                case .startFailed:          return "Failed to start workout"
                case .endFailed:            return "Failed to finish workout"
                case .didFailWithError:     return "Workout session did fail with Error"
                case .invalidCall:          return "Function called at inappropriate time"
                }
    }
    
    func log(file: String = #fileID, function: String = #function, line: Int = #line) {
        Swift.print("\(description) @ \(file):\(line) \(function)")
    }
    
    func log(_ msg: Error, file: String = #fileID, function: String = #function, line: Int = #line) {
        Swift.print("\(description): \(msg) @ \(file):\(line) \(function)")
    }
}
