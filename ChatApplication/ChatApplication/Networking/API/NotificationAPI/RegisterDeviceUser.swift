//
//  RegisterDeviceUser.swift
//  TetViet
//
//  Created by KienPT on 1/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class RegisterDeviceUser: APIOperation<RegisterDeviceResponse>{
    
    init() {
        var parameter = Parameters()
        if let tocken = SharedData.accessToken {
            parameter["registration_id"] = tocken
        }
        parameter["active"] = true
        parameter["type"] = "ios"
        super.init(request: APIRequest(name: "Register Device User", path: "personal/device", method: .post, expandedHeaders: [:], parameters: .body(parameter), enviroment: .jsonEnviroment))
    }
}

struct RegisterDeviceResponse: APIResponseProtocol {
    
    init(json: JSON) {
        
    }
}
