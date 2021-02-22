//
//  Pair.swift
//  YTeThongMinh
//
//  Created by DatTV on 5/29/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation

class Pair<T> {
    
    var key: String
    var value: T
    
    init(key: String, value: T) {
        self.key = key
        self.value = value
    }
}
