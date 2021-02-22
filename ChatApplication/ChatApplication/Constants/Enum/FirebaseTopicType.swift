//
//  FirebaseTopicType.swift
//  TetViet
//
//  Created by QuangLH on 1/17/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

enum FirebaseTopicType: String {
    case ios = "IOS"
    case male = "MALE"
    case female = "FEMALE"
    case less18 = "LT18"
    case less40 = "LT40"
    case less50 = "LT50"
    case greater50 = "GT50"
    case rikkei = "RIKKEI"
    
    init(age: Int) {
        if age < 18 {
            self = .less18
        } else if age >= 18 && age < 40 {
            self = .less40
        } else if age >= 40 && age < 50 {
            self = .less50
        } else {
            self = .greater50
        }
    }
    
    init(gender: Gender) {
        if gender == .male {
            self = .male
        } else {
            self = .female
        }
    }
    
    var otherTopicsUnsubscribe: [FirebaseTopicType] {
        switch self {
        case .male:
            return [.female]
        case .female:
            return [.male]
        case .less18:
            return [.less40, .less50, .greater50]
        case .less40:
            return [.less18, .less50, .greater50]
        case .less50:
            return [.less40, .less18, .greater50]
        case .greater50:
            return [.less40, .less50, .less18]
        case .rikkei:
            return [.rikkei]
        default:
            return [.ios]
        }
    }
}
