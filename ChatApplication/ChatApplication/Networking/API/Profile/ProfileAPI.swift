//
//  ProfileAPI.swift
//  YTeThongMinh
//
//  Created by DatTV on 6/3/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct BaseGetListResponse<T: BaseModel>: APIResponseProtocol {
    
    var data: [T] = []
    
    init(json: JSON) {
        
        for (index, item) in data.enumerated() {
            if item.name == "Khác" {
                data.remove(at: index)
                data.append(item)
                break
            }
        }
        data = json["data"].arrayValue.map {
            let t = T.init()
            t.setupData(json: $0)
            return t
        }
    }
}

class BaseModelRequestAPI<T: BaseModel> : APIOperation<BaseModelRequestResponse<T>> {
    init(api: APIPath, method: HTTPMethod = .get, params: [String: Any] = [:], endUrl: String? = nil) {
        super.init(request: APIRequest(name: "Base Model Request",
                                       path: api.rawValue + (endUrl ?? ""),
            method: method,
            parameters: .body(params),
            enviroment: APIEnviroment.jsonEnviroment))
    }
    
    enum APIPath: String {
        case healthService = "data/v0/healthservice/measurement/"
    }
}

struct BaseModelRequestResponse<T: BaseModel>: APIResponseProtocol {
    
    var data = T.init()
    var code: Int?
    
    init(json: JSON) {
        code = json["code"].int
        data.setupData(json: json["data"])
    }
}

class ObjectRequestAPI<T> : APIOperation<ObjectRequestResponse<T>> {
    init(api: APIPath, method: HTTPMethod = .get, params: [String: Any] = [:], endUrl: String? = nil) {
        super.init(request: APIRequest(name: "Json request",
                                       path: api.rawValue + (endUrl ?? ""),
            method: method,
            parameters: .body(params),
            enviroment: APIEnviroment.jsonEnviroment))
    }
    
    enum APIPath: String {
        case rattingDoctor = "api/v0/patient/advisory/rating" // method put
        case uploadAvatar = "api/v0/doctor/avatar"
        case deleteHealthService = "data/v0/healthservice/measurement/multi"  // method delete ids = arrray
    }
}

struct ObjectRequestResponse<T>: APIResponseProtocol {
    
    var data: T?
    var code: Int?
    
    init(json: JSON) {
        code = json["code"].int
        data = json["data"].rawValue as? T
    }
}


class DownloadAPI : APIOperation<DownloadResponse> {
    init(file: URL, url: String, method: HTTPMethod = .get, params: [String: Any] = [:], baseUrl: String? = nil) {
        let enviroment = APIEnviroment.emptyBaseEnviroment
        if let base = baseUrl {
            enviroment.set(baseUrl: base)
        }
        super.init(request: APIRequest(name: "download file",
                                       path: url,
            method: method,
            parameters: .download(file: file, parameters: params),
            enviroment: APIEnviroment.emptyBaseEnviroment))
    }
}

struct DownloadResponse: APIResponseProtocol {
        
    init(json: JSON) {
        
    }
}

class UploadFileAPI : APIOperation<UploadFileResponse> {
    init(files: [String : [URL]], api: APIPath, method: HTTPMethod = .post, params: [String: Any] = [:]) {
        super.init(request: APIRequest(name: "upload file",
                                       path: api.rawValue,
            method: method,
            parameters: .multipartFilesAndParams(files: files, parameters: params),
            enviroment: APIEnviroment.downloadEnviroment))
    }
    
    enum APIPath: String {
         case uploadAvatar = "api/v0/uploads/avatar"
         case certificate = "api/v0/uploads/certificates"
         case healthMeasurement = "api/v0/health-measurement/image"
     }
}

struct UploadFileResponse: APIResponseProtocol {
        
    init(json: JSON) {
        
    }
}


