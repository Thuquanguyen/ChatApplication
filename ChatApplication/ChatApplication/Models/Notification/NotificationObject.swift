//
//  NotificationObject.swift
//  TetViet
//
//  Created by QuangLH on 12/18/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class NotificationObject {
    var id: Int = 0
    var name: String = ""
    var registrationId: String = ""
    var deviceId: String = ""
    var active: Bool = false
    var dateCreated: String = ""
    var type: String = ""
    
    init() {}
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        registrationId = json["registration_id"].stringValue
        deviceId = json["device_id"].stringValue
        dateCreated = json["date_created"].stringValue
        type = json["type"].stringValue
        active = json["active"].boolValue
    }
}
