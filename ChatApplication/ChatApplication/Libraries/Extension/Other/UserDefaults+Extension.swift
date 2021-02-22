//
//  UserDefaults+Extension.swift
//  AICPeople-DEV
//
//  Created by Dat Tran on 4/6/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import CoreLocation


extension UserDefaults {
    static private let LOCATION = "location_"
    
    static var location: CLLocationCoordinate2D {
        get {
            if let loc = UserDefaults.standard.value(forKey: UserDefaults.LOCATION) as? [String: Double] {
                return CLLocationCoordinate2D.init(latitude: loc["lat"] ?? 0 , longitude: loc["lon"] ?? 0)
            }
            return CLLocationCoordinate2D.init(latitude: Constants.ProvinceLocation.lat, longitude: Constants.ProvinceLocation.lon)
        }
        set(value) {
            var data: [String: Double] = [:]
            data["lat"] = value.latitude
            data["lon"] = value.longitude
            UserDefaults.standard.set(data, forKey: UserDefaults.LOCATION)
        }
    }
}
