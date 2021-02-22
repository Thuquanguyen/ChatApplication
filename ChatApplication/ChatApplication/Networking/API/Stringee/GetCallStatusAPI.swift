//
//  GetCallStatusAPI.swift
//  YTeThongMinh
//
//  Created by PhuongTHN on 6/3/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetCallStatusAPI: APIOperation<GetCallStatusAPIResponse>{
    
    init(doctorId: String, patientId: String) {
        var parameter = Parameters()
        parameter["doctor_id"] = doctorId
        parameter["patient_id"] = patientId
        super.init(request: APIRequest(name: "Get Stringee Access Token API",
                                              path: "api/v0/call/period/call_status",
                                              method: .post,
                                              expandedHeaders: [:],
                                              parameters: .body(parameter),
                                              enviroment: .stringeeDevelopmentEnv))
    }
}

struct GetCallStatusAPIResponse: APIResponseProtocol {
    var callStatus: CallStatus?
    init(json: JSON) {
        callStatus = CallStatus(rawValue: json["data"]["status"].stringValue)
    }
}

enum CallStatus: String {
    case notServed = "NOTSERVED"
    case failed = "FAILED"
    case success = "SUCCESS"
}
