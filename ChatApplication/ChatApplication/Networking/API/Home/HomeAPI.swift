//
//  HomeAPI.swift
//  YTe-DEV
//
//  Created by DatTV on 5/30/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class FavoriteDoctorAPI: APIOperation<FavoriteDoctorResponse> {
    init(name: String? = nil, doctorId: Int? = nil,count: Int = 10,pageNum: Int = 1) {
        var body: [String: Any] = [:]
        body["name"] = name
        body["count"] = count
        body["page_size"] = 10
        body["page_num"] = pageNum
        super.init(request: APIRequest(name: "Lấy danh sách bác sĩ",
                                       path: doctorId != nil ? "api/v0/doctor/\(doctorId ?? -1)" : "api/v0/doctor/",
                                       method: .get,
                                       parameters: .body(body),
                                       enviroment: APIEnviroment.jsonEnviroment.set(encoding: APIConfiguration.encoding)))
    }
}

struct FavoriteDoctorResponse: APIResponseProtocol {
    
    var favorites = [FavoriteDoctor]()
    var doctor: FavoriteDoctor?
    
    init(json: JSON) {
        favorites = json["data"].arrayValue.map{ FavoriteDoctor(json: $0)}
        doctor = FavoriteDoctor(json: json["data"])
    }
}


class MeasurementDataHistoryAPI: APIOperation<MeasurementDataHistoryResponse> {
    init(patientId: Int?) {
        super.init(request: APIRequest(name: "3 lần do gần nhất",
                                       path: "data/v0/healthservice/measurement/\(patientId?.string ?? "")",
                                       method: .get,
                                       parameters: .body([:]),
                                       enviroment: APIEnviroment.jsonEnviroment.set(encoding: APIConfiguration.encoding)))
    }
}

struct MeasurementDataHistoryResponse: APIResponseProtocol {
    
    var measurementData = [MeasurementDataHistory]()
    
    init(json: JSON) {
        let data = json["data"].arrayValue
        let count = data.count
        for i in 0..<3 {
            if i < count {
                measurementData.append(MeasurementDataHistory(json: data[i]))
            } else {
                measurementData.append(MeasurementDataHistory())
            }
        }
    }
}
