//
//  NotificationAPI.swift
//  AIC Utilities People
//
//  Created by ANHTT-D1 on 5/9/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire

class NotificationAPI: APIOperation<HistoryNotificationResponse> {
    init(categories: String, offset: Int = 0) {
        let body = categories != "" ? ["categories": categories,
                                       "offset": offset] : ["offset": offset]
        super.init(request: APIRequest(name: "Get Notification",
                                       path: "personal/notifications",
                                       method: .get,
                                       parameters: .body(body),
                                       enviroment: APIEnviroment.jsonEnviroment.set(encoding: APIConfiguration.encoding)))
    }
}

struct HistoryNotificationResponse: APIResponseProtocol {
    
    var notificationObj = NotificationObj()
    
    init(json: JSON) {
        notificationObj = NotificationObj(json: json["results"])
    }
}
