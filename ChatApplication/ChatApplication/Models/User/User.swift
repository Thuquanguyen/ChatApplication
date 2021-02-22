//
//  User.swift
//  TetViet
//
//  Created by KienPT on 12/25/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject, NSCoding {
    
    var code: Int?
    var message: String?
    var newUser: Bool?
    var accessToken: String?
    var freshToken: String?
    var id: Int?
    var username: String?
    var gender: Gender?
    var uid: String?
    var provider: String?
    var dateOfBirth: Date?
    var latitude: Double?
    var longitude: Double?
    var extraInfo: String?
    var address: String?
    var avatarUser: String?
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        code = json["code"].int
        message = json["message"].string
        newUser = json["new_user"].bool
        accessToken = json["access_token"].string
        freshToken = json["fresh_token"].string
        id = json["data"]["id"].int
        username = json["data"]["name"].string
        if let genderStr = json["data"]["gender"].string {
            gender = Gender(rawValue: genderStr)
        }
        uid = json["data"]["uid"].string
        provider = json["data"]["provider"].string
        dateOfBirth = json["data"]["date_of_birth"].string?.dateBy(format: Constants.dateFormat, calendar: Date.currentCalendar, timeZone: Date.currentTimeZone)
        latitude = json["data"]["latitude"].double
        longitude = json["data"]["longitude"].double
        address = json["data"]["address"].string
        avatarUser = json["data"]["avatar"].string
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: "code")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(newUser, forKey: "newUser")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(freshToken, forKey: "freshToken")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(provider, forKey: "provider")
        aCoder.encode(dateOfBirth, forKey: "dateOftBirth")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(gender?.rawValue, forKey: "gender")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(avatarUser, forKey: "avatarUser")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        code         = aDecoder.decodeObject(forKey: "code") as? Int
        message      = aDecoder.decodeObject(forKey: "message") as? String
        newUser      = aDecoder.decodeObject(forKey: "newUser") as? Bool
        accessToken  = aDecoder.decodeObject(forKey: "accessToken") as? String
        freshToken   = aDecoder.decodeObject(forKey: "freshToken") as? String
        id           = aDecoder.decodeObject(forKey: "id") as? Int
        provider     = aDecoder.decodeObject(forKey: "provider") as? String
        dateOfBirth = aDecoder.decodeObject(forKey: "dateOftBirth") as? Date
        latitude     = aDecoder.decodeObject(forKey: "latitude") as? Double
        longitude    = aDecoder.decodeObject(forKey: "longitude") as? Double
        gender       = Gender(rawValue: aDecoder.decodeObject(forKey: "gender") as? String ?? "unknow")
        username     = aDecoder.decodeObject(forKey: "username") as? String
        address      = aDecoder.decodeObject(forKey: "address") as? String
        avatarUser      = aDecoder.decodeObject(forKey: "avatarUser") as? String
    }
}
