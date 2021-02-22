//
//  Collection+Extension.swift
//  AIC Utilities People
//
//  Created by Linh Ta on 8/28/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

extension Collection {
    func countAll(where condition: (Element) -> Bool) -> Int {
        return reduce(into: 0) { (result, item) in
            if condition(item) {
                result += 1
            }
        }
    }
}
