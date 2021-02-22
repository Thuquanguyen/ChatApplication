//
//  LoginAPI.swift
//  ATMCard
//
//  Created by Nguyen Huu Quan on 04/07/2019.
//  Copyright © 2019 quannh. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseCore
import FirebaseMessaging


class LoginAPI: APIOperation<LoginResponse> {
    init(userName: String, password: String?) {
        var params: [String: Any] = [:]
        params["UserName"] = userName
        params["Password"] = password
        params["FireBaseToken"] = Messaging.messaging().fcmToken
        super.init(request: APIRequest(name: "Login ▶︎ ", path: "LoginByPassword", method: .post, parameters: .body(params),enviroment: APIEnviroment.default))
    }
}

struct LoginResponse: APIResponseProtocol {
    
    // Variable from response data
//    var infoUser: UserModel?
    var statusCode: Int?
    var message: String?
    
    init(json: JSON) {
        print(json)
    }
}
