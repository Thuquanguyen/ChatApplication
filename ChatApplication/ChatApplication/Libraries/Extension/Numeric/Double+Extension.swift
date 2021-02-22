//
//  Double+Extension.swift
//  TetViet
//
//  Created by QuangLH on 1/4/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    func timestampToDate() -> Date? {
        let date = Date.init(timeIntervalSince1970: self)
        return date
    }
    
    var string: String {
        return String(self)
    }
}

extension NSDecimalNumber {
    
    var string: String? {
        if isNumeric {
            return stringValue
        }
        return nil
    }
    
    var isNumeric: Bool {
        return self != NSDecimalNumber.notANumber
    }
    
    var isZero: Bool {
        return self == NSDecimalNumber.zero
    }
}

extension Optional where Wrapped == NSDecimalNumber {
    
    var string: String? {
        if let x = self {
            return x.string
        }
        return nil
    }
    
    var isNumeric: Bool {
        if let x = self {
            return x.isNumeric
        }
        return false
    }
    
    var isZero: Bool {
        return self == NSDecimalNumber.zero
    }
}
