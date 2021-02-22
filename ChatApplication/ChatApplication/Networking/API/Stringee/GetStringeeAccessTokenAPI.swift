//
//  GetStringeeAccessTokenAPI.swift
//  YTeThongMinh
//
//  Created by PhuongTHN on 5/26/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetStringeeAccessTokenAPI: APIOperation<GetStringeeAccessTokenAPIResponse>{
    
    init(userId: Int) {
        var parameter = Parameters()
        parameter["account_id"] = userId
        let jsonString = parameter.jsonString!
        super.init(request: APIRequest(name: "Get Stringee Access Token API",
                                              path: "api/v0/call/stringee_token",
                                              method: .post,
                                              expandedHeaders: ["Content-Type":"application/json"],
                                              parameters: .raw(jsonString),
                                              enviroment: .stringeeDevelopmentEnv))
    }
}

struct GetStringeeAccessTokenAPIResponse: APIResponseProtocol {
    var stringeeAccessToken: String?
    init(json: JSON) {
        stringeeAccessToken = json["data"]["token"].string
    }
}
