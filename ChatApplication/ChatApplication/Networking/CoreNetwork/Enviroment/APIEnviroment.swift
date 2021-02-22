//
//  MainEnviroment.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/18/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIEnviroment: APIEnviromentProtocol {
    
    class var `default`: APIEnviroment {
        return APIEnviroment(baseUrl: APIConfiguration.baseUrl,
                             headers: APIConfiguration.userHeaders,
                             encoding: APIConfiguration.encoding,
                             timeout: APIConfiguration.timeout)
    }
    
    class var defaultPort: APIEnviroment {
        return APIEnviroment(baseUrl: APIConfiguration.baseUrlPort,
                             headers: APIConfiguration.userHeaders,
                             encoding: APIConfiguration.encoding,
                             timeout: APIConfiguration.timeout)
    }
    
    class var facebookPort: APIEnviroment {
        return APIEnviroment(baseUrl: APIConfiguration.fbURL,
                             headers: APIConfiguration.userHeaders,
                             encoding: APIConfiguration.encoding,
                             timeout: APIConfiguration.timeout)
    }
    
    class var jsonEnviroment: APIEnviroment {
        return APIEnviroment(baseUrl: APIConfiguration.baseUrl,
                             headers: APIConfiguration.userBearerAuthorizationHeaders,
                             encoding: JSONEncoding.default,
                             timeout: APIConfiguration.timeout)
    }
    
    class var downloadEnviroment: APIEnviroment {
        return APIEnviroment(baseUrl: APIConfiguration.baseUrlPort,
                             headers: APIConfiguration.userHeaders,
                             encoding: JSONEncoding.default,
                             timeout: APIConfiguration.timeout)
    }
      
    
    private static var ttsHeaders: HTTPHeaders {
        return ["api-key": Constants.openFptApiKey,
                "voice": SharedData.typeVoice.rawValue]
    }
    
    class var cloudsEnviroment: APIEnviroment {
        return APIEnviroment(baseUrl: APIConfiguration.cloudSttUrl,
                             headers: APIConfiguration.cloudsHeader,
                             encoding: JSONEncoding.default,
                             timeout: APIConfiguration.timeout)
    }

    class var stringeeTestingEnv: APIEnviroment {
        return APIEnviroment(baseUrl: "http://bangtv2.cf:8080/api/call/gettoken",
                             headers: [:],
                             encoding: APIConfiguration.encoding,
                             timeout: APIConfiguration.timeout)
    }
    
    class var stringeeDevelopmentEnv: APIEnviroment {
        return APIEnviroment(baseUrl: APIConfiguration.baseUrl,
                             headers: APIConfiguration.userBearerAuthorizationHeaders,
                              encoding: APIConfiguration.encoding,
                              timeout: APIConfiguration.timeout)
    }
    
    class var emptyBaseEnviroment: APIEnviroment {
        return APIEnviroment(baseUrl: "",
                             headers: APIConfiguration.userHeaders,
                             encoding: JSONEncoding.default,
                             timeout: APIConfiguration.timeout)
    }
    
    // Base URL of the enviroment (default is base url of current scheme)
    var baseUrl: String
    
    // HTTP headers of the enviroment (default is headers of current scheme)
    var headers: HTTPHeaders
    
    // URL encoding of the enviroment (default is Encoding Default type)
    var encoding: ParameterEncoding
    
    // Request timeout for request
    var timeout: TimeInterval
    
    // MARK: - Init
    init(baseUrl: String, headers: HTTPHeaders, encoding: ParameterEncoding, timeout: TimeInterval) {
        self.baseUrl = baseUrl
        self.headers = headers
        self.encoding = encoding
        self.timeout = timeout
    }
    
    func parseApiErrorJson(_ json: JSON, statusCode: Int?) -> APIError? {
        // Try to parse input json to error class according to your error json format
        // Example:
        guard let errorId = json["error_id"].int else { return nil }
        let errorMessage = json["error_message"].string
        return APIError.api(statusCode: statusCode,
                            apiCode: errorId,
                            message: errorMessage)
    }
    
    // MARK: - Builder
    @discardableResult
    func set(baseUrl: String) -> APIEnviroment {
        self.baseUrl = baseUrl
        return self
    }
    
    @discardableResult
    func set(headers: HTTPHeaders) -> APIEnviroment {
        self.headers = headers
        return self
    }
    
    @discardableResult
    func set(encoding: ParameterEncoding) -> APIEnviroment {
        self.encoding = encoding
        return self
    }
    
    @discardableResult
    func set(timeout: TimeInterval) -> APIEnviroment {
        self.timeout = timeout
        return self
    }
}
