//
//  SendOTPAPI.swift
//  YTe-DEV
//
//  Created by QuanNH on 5/30/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class SendOTPAPI: APIOperation<SendOTPResponse> {
    init(loginName: String, phone: String?) {
        var params: [String: Any] = [:]
        params["login_name"] = loginName
        params["role"] = APIConfiguration.roleApp
//        if let phone = phone {
//            params["phone_number"] = phone
//        }
        let rawText = params.jsonString ?? ""
        super.init(request: APIRequest(name: "Send OTP ▶︎ ",
                                       path: "api/v0/auth/otp",
                                       method: .put,
                                       expandedHeaders: ["Content-Type":"application/json"],
                                       parameters: .raw(rawText)))
    }
}

struct SendOTPResponse: APIResponseProtocol {
    
    // Variable from response data
//    var infoUser: UserModel?
    var statusCode: Int?
    var message: String?
    var code: Int?
    
    var errors: APIErrorsModel?
    
    init(json: JSON) {
        code = json["code"].int
        errors = APIErrorsModel(json: json["errors"])
    }
}
