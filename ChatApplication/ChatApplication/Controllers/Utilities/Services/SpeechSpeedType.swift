//
//  SpeechSpeedType.swift
//  TetViet
//
//  Created by QuangLH on 3/20/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

enum SpeechSpeedType {
    case slow
    case normal
    case fastNormal
    case fast
    case unknown
    
    init(key: String) {
        if key == "cham" {
            self = .slow
        } else if key == "trung_binh" {
            self = .normal
        } else if key == "nhanh_vua" {
            self = .fastNormal
        } else if key == "nhanh" {
            self = .fast
        } else {
            self = .unknown
        }
    }
    
    init(speed: Float) {
        switch speed {
        case 0.75:
            self = .slow
        case 1.25:
            self = .normal
        case 1.75:
            self = .fastNormal
        case 2.25:
            self = .fast
        default:
            self = .unknown
        }
    }
    
    var value: Float {
        switch self {
        case .slow:
            return 0.75
        case .normal:
            return 1.0
        case .fastNormal:
            return 1.75
        case .fast:
            return 2.25
        default:
            return 1.0
        }
    }
}
