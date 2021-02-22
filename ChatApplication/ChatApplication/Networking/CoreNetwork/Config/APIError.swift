//
//  ErrorExtension.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

public enum APIError {
    case api(statusCode: Int?, apiCode: Int?, message: String?)
    case request(statusCode: Int?, error: Error?, errorMessage: String? = nil, apiErrors: APIErrorsModel? = nil)
    
    var apiCode: Int? {
        switch self {
        case .api(_, let apiCode, _):
            return apiCode
        default:
            return nil
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .api(let statusCode, _, _):
            return statusCode
        case .request(let statusCode, _, _, _):
            return statusCode
        }
    }
    
    var message: String? {
        switch self {
        case .api(_, _, let message):
            return message
        case .request(_, let error, let errorMessage, _):
            guard let error = error else {
                return "Có lỗi xảy ra, vui lòng thử lại "
            }
            if error.isInternetOffline || error.isNetworkConnectionLost  {
                return "Không có kết nối Internet, vui lòng thử lại."
            }
            
            if error.isHostConnectFailed {
                return "Không thể kết nối máy chủ."
            }
            
            if error.isTimeout {
                return "Quá thời gian kết nối tới máy chủ, vui lòng thử lại"
            }
            if error.isBadServerResponse {
                return "Lỗi kết nối"
            }
            
            //API Error
            if errorMessage == APIErrorHttpMessage.notFound {
                return "Không tìm thấy nội dung tương ứng"
            }
            if self.statusCode == APIErrorHttpCode.notFound {
                return "Xin lỗi, nội dung hiện tại không khả dụng"
            }
            if self.statusCode == APIErrorHttpCode.invalidToken && self.apiErrors?.httpError.errCodeString == "ACESS_DENIED" {
                Utils.removeUser()

                return "Phiên đăng nhập của bạn đã hết hạn"
            }
            if self.statusCode == APIErrorHttpCode.deleted {
                return "Xin lỗi, nội dung không tồn tại hoặc đã bị xoá"
            }
            return "Có lỗi xảy ra, vui lòng thử lại "
        }
    }
    
    var apiErrors: APIErrorsModel? {
        switch self {
        case .request(_, _,  _, let error):
            return error
        default:
            return nil
        }
    }
    
    // Create an unknown api error
    static var unknown: APIError {
        return APIError.request(statusCode: nil, error: nil)
    }
    
    struct APIErrorHttpCode {
        static let notFound = 404
        static let invalidToken = 403
        static let deleted = 422
    }
    
    struct APIErrorHttpMessage {
        static let notFound = "Not found data." //404 Content not found
        static let notPermit = "Not permit"
    }
}

class Validation {
       var field: String?
       var message: String?
       var action: String?
       var nodeID: String?
       var expected: String?
       var type: String?
       var actual: String?
       
       init(json: JSON) {
           field = json["field"].string
           type = json["type"].string
       }
   }
