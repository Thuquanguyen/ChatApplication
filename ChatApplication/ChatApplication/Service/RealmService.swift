//
//  RealmService.swift
//  TetViet
//
//  Created by vinhdd on 12/18/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import RealmSwift

class RealmService {
    // MARK: - Singleton
    static var instance = RealmService()
    
    
    //MARK:- Remove realm file
    static func removeFile() {
        try? FileManager.default.removeItem(atPath: Realm.Configuration.defaultConfiguration.fileURL?.path ?? "")
    }
    
    // MARK: - Supporting function
    func write(_ handler: ((_ realm: Realm) -> Void)) {
        do {
            let realm = try Realm()
            try realm.write {
                handler(realm)
            }
        } catch {
        
        }
    }
    
    func deleteAll() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            
        }
    }
    
    func load<T: Object>(listOf: T.Type, filter: String? = nil, distinctBy: [String] = []) -> [T] {
        do {
            var objects = try Realm().objects(T.self).distinct(by: distinctBy)
            if let filter = filter {
                objects = objects.filter(filter)
            }
            var list = [T]()
            for obj in objects {
                list.append(obj)
            }
            return list
        } catch { }
        return []
    }
    
    func add<T: Object>(object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete<T: Object>(type: T.Type, condition: String? = nil) {
        for item in load(listOf: T.self, filter: condition) {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(item)
                }
            } catch {
            }
        }
    }
    
    func delete(object: Object) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
        } catch { }
    }
    
    func updateStory(id: Int, with index: Int) {
    }    
}

