//
//  Date.swift
//  YTeThongMinh
//
//  Created by ThuNQ on 6/11/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
extension Date {
    mutating func changeDays(by days: Int) -> Date{
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
