//
//  Int+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//
import Foundation

extension Int {

    var string : String {
        return String(self)
    }
    
    func addCommaWith(separator: String = ",") -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = separator
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))
    }
    
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
    func toRatingOptionString() -> String {
        switch self {
        case Constants.RatingOption.good:
            return "Good"
        case Constants.RatingOption.normal:
            return "normal"
        case Constants.RatingOption.bad:
            return "bad"
        default:
            return ""
        }
    }
    
    // format number to k's format
    func formatKNumber() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)B"
        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)M"
        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)K"
        case 0...:
            return "\(self)"
        default:
            return "\(sign)\(self)"
        }
    }
    
}
