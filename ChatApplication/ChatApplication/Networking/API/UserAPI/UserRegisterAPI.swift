//
//  UserRegisterAPI.swift
//  TetViet
//
//  Created by KienPT on 12/25/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UserRegisterAPI: APIOperation<UserRegisterResponse> {
    struct ParamsGroup {
        var userName: String?
        var provider: LoginType?
        var uid: String?
        var latitude: Float?
        var longitude: Float?
        var birthday: String?
        var gender: Gender?
        var address: String?
        var token: String?
        var avatar: String?
        var email: String?
    }
    
    init(params: ParamsGroup) {
        var parameters: Parameters = [:]
        parameters["user_name"] = params.userName ?? ""
        parameters["provider"] = params.provider?.rawValue
        parameters["uid"] = params.uid
        parameters["latitude"] = params.latitude
        parameters["longitude"] = params.longitude
        if let birth = params.birthday { parameters["date_of_birth"] = birth }
        if params.gender == Gender.male {
            parameters["gender"] = "male"
        } else if params.gender == Gender.female {
            parameters["gender"] = "female"
        }
        parameters["access_token"] = params.token
        if let address = params.address { parameters["address"] = address }
        parameters["extra_info"] = "{}"
        parameters["avatar"] = params.avatar
        parameters["email"] = params.email
        super.init(request: APIRequest(name: "User Register",
                                       path: "personal/",
                                       method: .post,
                                       expandedHeaders: [:],
                                       parameters: .body(parameters),
                                       enviroment: .jsonEnviroment))
    }
}

struct UserRegisterResponse: APIResponseProtocol {
    
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        user = User(json: json["result"])
        
    }
}


class GetUserInfoAPI: APIOperation<GetUserInfoResponse> {
    init() {
        super.init(request: APIRequest(name: "Get User Info",
                                       path: "personal/detail",
                                       method: .get,
                                       expandedHeaders: APIConfiguration.userBearerAuthorizationHeaders,
                                       parameters: .body([:])
                                       ))
    }
}

struct GetUserInfoResponse: APIResponseProtocol {
    
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        user = User(json: json["results"])
        
    }
}
