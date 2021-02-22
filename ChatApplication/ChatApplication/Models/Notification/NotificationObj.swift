//
//  NotificationObj.swift
//  AIC Utilities People
//
//  Created by ANHTT-D1 on 5/9/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class NotificationObj {
    var page: Int = 0
    var totalItems: Int = 0
    var itemPerPage: Int = 0
    var apiVersion: String = ""
    var notifications: [NotificationModel] = []
    var linkNext: String?
    var linkPrevious: String?
    
    init() {}
    
    init(json: JSON) {
        page = json["page"].intValue
        totalItems = json["total_items"].intValue
        itemPerPage = json["item_per_page"].intValue
        apiVersion = json["api_version"].stringValue
        linkNext = json["links"]["next"].string
        linkPrevious = json["links"]["previous"].string
        if let items = json["data"].array {
            for item in items {
                notifications.append(NotificationModel(json: item))
            }
        }
    }
}
