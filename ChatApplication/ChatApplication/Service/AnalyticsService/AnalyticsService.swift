//
//  AnalyticsService.swift
//  AIC Utilities People
//
//  Created by IchNV-D1 on 9/5/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class AnalyticsService {
    
    // Logging functions
    static func log(screen: AnalyticsInfoKey.Screen?, parameters: [String: Any]? = nil) {
        if let screen = screen {
            Analytics.logEvent(screen.name, parameters: parameters)
            
            print("-> [AnalyticsService] Logging screen: \(screen.name)")
        }
    }
    
    static func log(button: AnalyticsInfoKey.Button?, parameters: [String: Any]? = nil) {
        if let button = button {
            Analytics.logEvent(button.name, parameters: parameters)
            print("-> [AnalyticsService] Logging button: \(button.name)")
        }
    }
}

