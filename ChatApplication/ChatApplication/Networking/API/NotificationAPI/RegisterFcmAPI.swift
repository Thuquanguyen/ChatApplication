//
//  RegisterFcmAPI.swift
//  TetViet
//
//  Created by QuangLH on 12/18/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import FirebaseMessaging

class RegisterFcmAPI: APIOperation<NotificationResponse> {
    
    init() {
        let isLogined = SharedData.accessToken != nil
        let path = isLogined ? "noti/v0/fbtoken/" : "noti/v0/fbtoken/"
        let environment = isLogined ? APIEnviroment.default.set(headers: APIConfiguration.userBearerAuthorizationHeaders) : APIEnviroment.default
        super.init(request: APIRequest(name: "Register notification",
                                       path: path,
                                       method: .post,
                                       parameters: .body(["newToken" : Messaging.messaging().fcmToken ?? "",
                                                    "oldToken" : Messaging.messaging().fcmToken ?? ""]),
                                       enviroment: environment))
    }
}

struct NotificationResponse: APIResponseProtocol {
    
    var notiObj: NotificationObject = NotificationObject()
    
    init(json: JSON) {
        // Parse json data from server to local variables
        notiObj = NotificationObject(json: json)
    }
}
