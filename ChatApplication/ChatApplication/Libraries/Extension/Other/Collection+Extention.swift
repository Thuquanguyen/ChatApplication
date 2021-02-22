//
//  Collection+Extention.swift
//  AICPeople-DEV
//
//  Created by Dat Tran on 4/14/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation

public extension Collection {
    subscript (safe index: Index?) -> Element? {
        if let index = index, indices.contains(index) {
            return self[index]
        }
        return nil
    }
}
