//
//  GetUserInfomationAPI.swift
//  YTeThongMinh
//
//  Created by PhuongTHN on 7/4/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetUserInfomationAPI: APIOperation<GetUserInfomationAPIResponse>{
    
    let env = APIEnviroment(baseUrl: APIConfiguration.baseUrl,
                            headers: APIConfiguration.userBearerAuthorizationHeaders,
                            encoding: URLEncoding.default,
                            timeout: APIConfiguration.timeout)
    init(accountList: [String]) {
        var parameter = Parameters()
        parameter["account_list"] = "\(accountList)"
        
        super.init(request: APIRequest(name: "Get User Information by Id",
                                              path: "api/v0/account/info",
                                              method: .get,
                                              parameters: .body(parameter),
                                              enviroment: env))
    }
}

struct GetUserInfomationAPIResponse: APIResponseProtocol {
    var userInformations = [UserInformation]()
    init(json: JSON) {
        userInformations = json["data"].arrayValue.map { UserInformation(json: $0) }
    }
}

class UserInformation: NSObject {
    var role: String = ""
    var name: String = ""
    var patientId: Int = 0
    var accountId: Int = 0
    var avatar: String = ""
    var doctorID: Int? = 0
    var isVideoCall: Bool? = false
    
    override init() {
        
    }
    
    init(json: JSON) {
        self.role = json["role"].stringValue
        self.name = json["name"].stringValue
        self.patientId = json["patient_id"].intValue
        self.accountId = json["account_id"].intValue
        self.avatar = json["avatar"].stringValue
        self.doctorID = json["doctor_id"].intValue
        self.isVideoCall = json["is_videocall_available"].boolValue
    }
}

