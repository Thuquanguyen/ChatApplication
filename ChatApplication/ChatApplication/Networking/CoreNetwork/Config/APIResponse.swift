//
//  APIResponse.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

// Define response data types for each request
public enum APIResponse {
    case success(_: JSON)
    case error(_: APIError)
    
    init(_ response: DataResponse<Any>, fromRequest request: APIRequest) {
        // Get status code
        let statusCode = response.response?.statusCode
        
        // Check if the request error exists
        if let error = response.result.error {
            var errorMessage: String?
            if let data = response.data {
                if let json = try? JSON.init(data: data) {
                    print(json)
                    errorMessage = json["name"].string
                    let errors = APIErrorsModel(json: json["errors"])
                    self = .error(APIError.request(statusCode: statusCode, error: error, errorMessage: errorMessage, apiErrors: errors))
                    return
                }
            }
            self = .error(APIError.request(statusCode: statusCode, error: error))
            return
        }
        
        if let authorization = response.response?.allHeaderFields["Authorization"] as? String {
//            User.shared.authorization = authorization
            SharedData.accessToken = authorization
            Constants.debug(title: "authorization: \(authorization)")
        }
        
        // Check if response has data or not
        guard let jsonData = response.result.value else {
            self = .error(APIError.request(statusCode: statusCode, error: response.error))
            return
        }
        
        // Try to parse api error if possible
        let json: JSON = JSON(jsonData)
        if let error = request.enviroment.parseApiErrorJson(json, statusCode: statusCode) {
            self = .error(error)
            return
        }
        
        // Get data successfully
        self = .success(json)
    }
}

// Model repsonse protocol based on JSON data (View Controller's layers are able to view this protocol as response data)
public protocol ModelResponseProtocol {
    // Set json as input variable
    init(json: JSON)
}

// Model repsonse protocol based on JSON data (View Controller's layers are able to view this protocol as response data)
public protocol APIResponseProtocol {
    
    // Set json as input variable
    init(json: JSON)
}

public struct APIErrorsModel {
    
    var validationError: [Validation] = []
    var httpError: HttpError = HttpError()
    var isSuccess = false
    var errorDefine: APIErrorsDefine?
    
    init(json: JSON) {
        validationError = json["validationError"].array?.map({ (item) in
            return Validation(json: item)
        }) ?? []
        httpError = HttpError(json: json["httpResponseError"])
        if validationError.count == 0 && httpError.errCode == nil && httpError.httpCode == nil {
            isSuccess = true
        }
        errorDefine = APIErrorsDefine(errorCode: httpError.errCode, httpCode: httpError.httpCode, validation: validationError)
    }

    public class HttpError {
        var message: String?
        var httpCode: Int?
        var errCode: Int?
        var errCodeString: String?
        
        init() {}

        init(json: JSON) {
            errCodeString = json["err_code"].stringValue
            errCode = json["err_code"].int
            httpCode = json["http_code"].int
            message = json[""].string
        }
    }
    
    //No need anything here just for check error
    public class Validation {
        var field: String?
        var message: String?
        var action: String?
        var nodeID: String?
        var expected: String?
        var type: String?
        var actual: String?
        var enumType: EnumType = .none
        
        init(json: JSON) {
            field = json["field"].string
            type = json["type"].string
            enumType = EnumType(rawValue: type ?? "") ?? .none
        }
    }
    
    public enum EnumType: String {
        case email = "email"
        case phoneNumber = "phone_number"
        case none
    }
}

struct APIErrorsDefine {
    
    /*
     * Nếu message nil là success
     */
    var message: String? = nil
    var messageErrorNotFound = "Lỗi từ máy chủ. Máy chủ chưa sẵn sàng. Bạn hãy thử lại!"
    
    init(errorCode: Int?, httpCode: Int?, validation: [APIErrorsModel.Validation]) {
        var messages: [String] = []
        if validation.count > 0 {
            validation.forEach {
                switch $0.enumType {
                case .email:
                    messages.append("Email chưa đúng định dạng. Hãy kiểm tra lại!")
                case .phoneNumber:
                    messages.append("Số điện thoại không đúng. Hãy kiểm tra lại!")
                default:
                    break
                }
            }
            if messages.isEmpty {
                messages.append("Thông tin bạn nhập vào chưa chính xác. Hãy kiểm tra lại!")
            }
        } else {
            guard let error = errorCode, let http = httpCode else {
                return
            }
            switch http {
            case 400:
                switch error {
                case 151:
                    messages.append("Số điện thoại đã được đăng ký!")
                case 159:
                    messages.append("Email đã được sử dụng!")
                case 152:
                    messages.append("Đăng ký không thành công. Mời bạn thử lại hoặc liên hệ hotline!")
                default:
                    break
                }
            case 403:
                switch error {
                case 151:
                    messages.append("Số điện thoại đã được đăng ký!")
                case 159:
                    messages.append("Email đã được sử dụng!")
                case 152:
                    messages.append("Đăng ký không thành công. Mời bạn thử lại hoặc liên hệ hotline!")
                case 111,112,113:
                    Utils.removeUser()
                default:
                    break
                }
            case 404:
                switch error {
                case 153:
                    messages.append("Người dùng không tồn tại!")
                default:
                    break
                }
            case 503:
                switch error {
                case 100:
                    messages.append("Lỗi từ phía máy chủ! Hãy liên hệ hotline để được trợ giúp!")
                default:
                    break
                }
            default:
                break
            }
            if messages.isEmpty {
                messages.append(messageErrorNotFound)
            }
        }
        if !messages.isEmpty {
            message = messages.joined(separator: "\n")
        }
    }
}
