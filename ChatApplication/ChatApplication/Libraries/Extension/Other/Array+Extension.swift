//
//  Array+Extension.swift
//  YTeThongMinh
//
//  Created by PhuongTHN on 6/5/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
extension Array {
    mutating func removeAtIndexes(indexes: IndexSet) {
        var i:Index? = indexes.last
        while i != nil {
            self.remove(at: i!)
            i = indexes.integerLessThan(i!)
        }
    }
}

// MARK: - Subscript

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
