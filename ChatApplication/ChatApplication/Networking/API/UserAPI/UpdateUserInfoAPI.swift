//
//  UpdateUserInfoAPI.swift
//  TetViet
//
//  Created by KienPT on 12/29/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UpdateUserInfoAPI: APIOperation<UpdateUserInfoResponse> {
    struct ParamsGroup {
        var latitude: Float?
        var longitude: Float?
        var birthday: String?
        var gender: Gender?
        var address: String?
        var extraInfo: String?
        var name: String?
        var avatar: String?
    }
    
    init(params: ParamsGroup, listData: [Data], accessToken: String) {
        var parameters: Parameters = [:]
        parameters["user_name"] = params.name
        parameters["latitude"] = params.latitude
        parameters["longitude"] = params.longitude
        if params.gender == Gender.male {
            parameters["gender"] = "male"
        } else if params.gender == Gender.female {
            parameters["gender"] = "female"
        }
        if let address = params.address { parameters["address"] = address }
        parameters["extra_info"] = "{}"
       // parameters["avatar"] = params.avatar
        parameters["date_of_birth"] = params.birthday
        
        var headers: HTTPHeaders = [:]
//        headers["CLIENTAPIKEY"] = APIConfiguration.clientApiKey
        headers["Authorization"] = "Bearer " + accessToken
        
        super.init(request: APIRequest(name: "User update info",
                                       path: "personal/update",
                                       method: .post,
                                       expandedHeaders: headers,
                                       parameters: .multipartWithCover(datas: listData, parameters: parameters, name: "avatar", fileName: "image.jpg", mimeType: "jpg", coverImage: nil),
                                       enviroment: .jsonEnviroment))
    }
}

struct UpdateUserInfoResponse: APIResponseProtocol {
    
    var user: User?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        user = User(json: json["result"])
    }
}
