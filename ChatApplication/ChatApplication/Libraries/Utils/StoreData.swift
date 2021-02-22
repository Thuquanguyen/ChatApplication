//
//  StoreData.swift
//  FootballX
//
//  Created by TrungHD-D1 on 14.09.17.
//  Copyright © 2017 Truhoada. All rights reserved.
//

import UIKit

class StoreData {
    
    //MARK: STORE
    static func storeString(value: String, key: String) -> Void {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func storeBool(value: Bool, key: String) -> Void {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func storeIntArray(value: [Int], key: String) -> Void {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func storeStringArray(value: [String], key: String) -> Void {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    //MARK: RETRIEVE
    static func retrieveString(key: String?) -> String? {
        if let result: String = (UserDefaults.standard.object(forKey: key!) as? String) {
            return result
        } else {
            return nil
        }
    }
    
    static func retrieveBool(key: String?) -> Bool? {
        if let result: Bool = (UserDefaults.standard.object(forKey: key!) as? Bool) {
            return result
        } else {
            return nil
        }
    }
    
    static func retrieveIntArray(key: String?) -> [Int]? {
        if let result: [Int] = (UserDefaults.standard.object(forKey: key!) as? [Int]) {
            return result
        } else {
            return nil
        }
    }
    
    static func retrieveStringArray(key: String?) -> [String]? {
        if let result: [String] = (UserDefaults.standard.object(forKey: key!) as? [String]) {
            return result
        } else {
            return nil
        }
    }
    
    
    //MARK: REMOVE
    static func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    //MARK: REMOVE ALL
    static func removeAll() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
   
    }

struct StorageKey {
    struct HistorySearch {
        static let newsSearch = "HistoryNewsSearchStorageKey"
    }
}

