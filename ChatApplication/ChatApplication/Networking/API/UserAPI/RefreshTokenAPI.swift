//
//  RefreshTokenAPI.swift
//  AIC Utilities People
//
//  Created by QuanNH-D1 on 9/7/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class RefreshTokenAPI: APIOperation<RefreshTokenResponse> {
    
    let envoriment = APIEnviroment.default.set(headers: APIConfiguration.userBearerAuthorizationHeaders)
    init() {
        super.init(request: APIRequest(name: "User refresh token",
                                       path: "personal/refeshtoken",
                                       method: .post,
                                       parameters: .body([:]),
                                       enviroment: envoriment))
    }
}

struct RefreshTokenResponse: APIResponseProtocol {
    
    var isSuccess = false
    
    init(json: JSON) {
        if json["result"]["code"].intValue == 200 {
            SharedData.accessToken = json["result"]["access_token"].string
            SharedData.freshToken = json["result"]["fresh_token"].string
            isSuccess = true
        }
    }
}
