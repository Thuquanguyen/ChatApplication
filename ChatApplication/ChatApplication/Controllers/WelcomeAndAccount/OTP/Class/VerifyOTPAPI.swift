//
//  VerifyOTPAPI.swift
//  YTe-DEV
//
//  Created by QuanNH on 5/30/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class VerifyOTPAPI: APIOperation<VerifyOTPResponse> {
    init(loginName: String, otp: String) {
        var params: [String: Any] = [:]
        params["login_name"] = loginName
        params["otp"] = otp
        params["role"] = APIConfiguration.roleApp
        let rawText = params.jsonString ?? ""
        super.init(request: APIRequest(name: "Send OTP ▶︎ ",
                                       path: "api/v0/auth/verify",
                                       method: .post,
                                       expandedHeaders: ["Content-Type":"application/json"],
                                       parameters: .raw(rawText)))
    }
}

struct VerifyOTPResponse: APIResponseProtocol {
    
    // Variable from response data
    var errors: APIErrorsModel?
    var code: Int?
    
    init(json: JSON) {
        code = json["code"].int
        errors = APIErrorsModel(json: json["errors"])
    }
}
