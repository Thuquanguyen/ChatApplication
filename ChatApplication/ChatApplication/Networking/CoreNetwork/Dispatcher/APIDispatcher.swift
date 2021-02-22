//
//  NetworkDispatcher.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIDispatcher: APIDispatcherProtocol {
    // Singleton variable for using default network enviroment
    //static var shared = NetworkDispatcher(enviroment: APIEnviroment.default)
    
    // MARK: - Variables
    weak var target: UIViewController?
    private var request: APIRequest?
    private var completionHandler: ((_ response: APIResponse) -> Void)?
    
    // MARK: - Init & deinit
    init() {
        APIProcessingManager.instance.add(dispatcher: self)
    }
    
    // MARK: - Request API task
    private var dataRequest: DataRequest?
    private var uploadRequest: UploadRequest?
    
    func execute(request: APIRequest, completed: @escaping ((_ response: APIResponse) -> Void)) {
        self.request = request
        self.completionHandler = completed
        // Check case of request's parameters
        switch request.parameters {
        case let .multipartMultiImage(images, params):
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for image in images {
                        guard let data = image.data else { continue }
                        multipartFormData.append(data, withName: image.keyName, fileName: image.fileName, mimeType: image.mineType)
                    }
                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
            }, usingThreshold: UInt64(), to: request.asFullUrl, method: request.method, headers: prepareHeadersForMultipartOrBinary(request: request)) { (result) in
                switch result {
                case .success(let upload, _, _):
                    self.uploadRequest = upload.responseJSON { [weak self] data in
                        guard let sSelf = self else { return }
                        completed(APIResponse(data, fromRequest: request))
                        APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                        print("▶︎ [API Processing Manager] Removed multipart request from list for screen: \(sSelf.target?.name ?? "none") !")
                    }
                    
                case .failure(let error):
                    let apiError = APIError.request(statusCode: nil, error: error)
                    completed(APIResponse.error(apiError))
                }
            }
        case let .multipartFilesAndParams(files, params):
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in files {
//                        guard let data = try? Data(contentsOf: value) else { continue }
//                        multipartFormData.append(data, withName: key, fileName: value.lastPathComponent, mimeType: value.mimeType())
                        value.forEach {
                            multipartFormData.append($0, withName: key, fileName: $0.lastPathComponent, mimeType: $0.mimeType())
                        }
                    }
                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
            }, usingThreshold: UInt64(), to: request.asFullUrl, method: request.method, headers: prepareHeadersForMultipartOrBinary(request: request)) { (result) in
                switch result {
                case .success(let upload, _, _):
                    self.uploadRequest = upload.responseJSON { [weak self] data in
                        guard let sSelf = self else { return }
                        completed(APIResponse(data, fromRequest: request))
                        APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                        print("▶︎ [API Processing Manager] Removed multipart request from list for screen: \(sSelf.target?.name ?? "none") !")
                    }
                    
                case .failure(let error):
                    let apiError = APIError.request(statusCode: nil, error: error)
                    completed(APIResponse.error(apiError))
                }
            }
            
        case .multiImageAndFile(let imageDatas, let fileDatas, let parameters, let image, let imageName, let imageType, let filePrefix, let fileName, let fileType):
            let fullHttpHeaders = prepareHeadersForMultipartOrBinary(request: request)
            Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let valueData = "\(value)".data(using: String.Encoding.utf8) {
                        multipartFormData.append(valueData, withName: key as String)
                    }
                }
                
                for (key, data) in imageDatas.enumerated() {
                    if let data = data {
                        if key == 0 {
                            multipartFormData.append(data, withName: image, fileName: imageName, mimeType: imageType)
                        } else {
                            multipartFormData.append(data, withName: image + "_\(key + 1)", fileName: imageName, mimeType: imageType)
                        }
                    }
                }
                
                for i in 0 ..< fileDatas.count {
                    if let data = fileDatas[i] {
                        if i == 0 {
                            multipartFormData.append(data, withName: filePrefix, fileName: fileName[i], mimeType: fileType[i])
                        } else {
                            multipartFormData.append(data, withName: filePrefix + "_\(i + 1)", fileName: fileName[i], mimeType: fileType[i])
                        }
                    }
                }
            }, usingThreshold: UInt64(), to: request.asFullUrl, method: request.method, headers: fullHttpHeaders) { (result) in
                switch result {
                case .success(let upload, _, _):
                    self.uploadRequest = upload.responseJSON { [weak self] data in
                        guard let sSelf = self else { return }
                        completed(APIResponse(data, fromRequest: request))
                        APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                        print("▶︎ [API Processing Manager] Removed multipart request from list for screen: \(sSelf.target?.name ?? "none") !")
                    }
                    
                case .failure(let error):
                    let apiError = APIError.request(statusCode: nil, error: error)
                    completed(APIResponse.error(apiError))
                }
            }
        case .body:
            let urlRequest = prepareBodyFor(request: request)
            self.dataRequest = Alamofire.request(urlRequest).validate().responseJSON(completionHandler: { [weak self] data in
                guard let sSelf = self else { return }
                completed(APIResponse(data, fromRequest: request))
                APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                print("▶︎ [API Processing Manager] Removed body request from list for screen: \(sSelf.target?.name ?? "none") !")
            })
        case .querryString:
            let urlReq = try? prepareQuerryFor(request: request)
            guard let urlReq1 = urlReq else {
                completed(APIResponse.error(APIError.unknown))
                return
            }
            
            guard let urlRequest = urlReq1 else {
                completed(APIResponse.error(APIError.unknown))
                return
            }
            
            self.dataRequest = Alamofire.request(urlRequest).validate().responseJSON(completionHandler: { [weak self] data in
                guard let sSelf = self else { return }
                completed(APIResponse(data, fromRequest: request))
                APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                print("▶︎ [API Processing Manager] Removed body request from list for screen: \(sSelf.target?.name ?? "none") !")
            })
        case .raw(let text):
            guard let rawRequest = prepareRawFor(request: request, rawText: text) else {
                completed(APIResponse.error(APIError.unknown))
                return
            }
            self.dataRequest = Alamofire.request(rawRequest).responseJSON(completionHandler: { [weak self] data in
                guard let sSelf = self else { return }
                completed(APIResponse(data, fromRequest: request))
                APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                print("▶︎ [API Processing Manager] Removed raw request from list for screen: \(sSelf.target?.name ?? "none") !")
            })
        case .multipart(let datas, let parameters, let name, let fileName, let mimeType):
            let fullHttpHeaders = prepareHeadersForMultipartOrBinary(request: request)
            Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let valueData = "\(value)".data(using: String.Encoding.utf8) {
                        multipartFormData.append(valueData, withName: key as String)
                    }
                }
                
                for (key, data) in datas.enumerated() {
                    if let data = data {
                        multipartFormData.append(data, withName: name + "_\(key + 1)", fileName: fileName, mimeType: mimeType)
                    }
                }
                
            }, usingThreshold: UInt64(), to: request.asFullUrl, method: request.method, headers: fullHttpHeaders) { (result) in
                switch result {
                case .success(let upload, _, _):
                    self.uploadRequest = upload.responseJSON { [weak self] data in
                        guard let sSelf = self else { return }
                        completed(APIResponse(data, fromRequest: request))
                        APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                        print("▶︎ [API Processing Manager] Removed multipart request from list for screen: \(sSelf.target?.name ?? "none") !")
                    }
                case .failure(let error):
                    let apiError = APIError.request(statusCode: nil, error: error)
                    completed(APIResponse.error(apiError))
                }
            }
        case .multipartWithCover(let datas, let parameters, let name, let fileName, let mimeType, let coverImage):
            let fullHttpHeaders = prepareHeadersForMultipartOrBinary(request: request)
            Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let valueData = "\(value)".data(using: String.Encoding.utf8) {
                        multipartFormData.append(valueData, withName: key as String)
                    }
                }
                
                
                for (key, data) in datas.enumerated() {
                    if let data = data, !data.isEmpty, key < 10 { //Limit 10 images
                        if let cover = coverImage {
                            if key == 0 {
                                multipartFormData.append(data, withName: cover, fileName: fileName, mimeType: mimeType)
                            } else {
                                multipartFormData.append(data, withName: name + "_\(key + 1)", fileName: fileName, mimeType: mimeType)
                            }
                        } else {
                            if key == 0 {
                                multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
                            } else {
                                multipartFormData.append(data, withName: name + "_\(key + 1)", fileName: fileName, mimeType: mimeType)
                            }
                        }
                    }
                }
                
            }, usingThreshold: UInt64(), to: request.asFullUrl, method: request.method, headers: fullHttpHeaders) { (result) in
                switch result {
                case .success(let upload, _, _):
                    self.uploadRequest = upload.responseJSON { [weak self] data in
                        guard let sSelf = self else { return }
                        completed(APIResponse(data, fromRequest: request))
                        APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                        print("▶︎ [API Processing Manager] Removed multipart request from list for screen: \(sSelf.target?.name ?? "none") !")
                    }
                case .failure(let error):
                    let apiError = APIError.request(statusCode: nil, error: error)
                    completed(APIResponse.error(apiError))
                }
            }
        case .binary( let data):
            let fullHttpHeaders = prepareHeadersForMultipartOrBinary(request: request)
            self.uploadRequest = Alamofire.upload(data, to: request.asFullUrl, method: request.method, headers: fullHttpHeaders).responseJSON { [weak self] response in
                guard let sSelf = self else { return }
                completed(APIResponse(response, fromRequest: request))
                APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                print("▶︎ [API Processing Manager] Removed binary request from list for screen: \(sSelf.target?.name ?? "none") !")
            }
        case .upload(let parameters):
            let params = parameters
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for param in params {
                        if let paramName = param["name"] as? String {
                            if let fileName = param["fileName"] as? String, let contentType = param["Content-Type"] as? String {
                                do {
                                    let fileUrl = URL(fileURLWithPath: fileName)
                                    multipartFormData.append(fileUrl, withName: paramName, fileName: fileUrl.lastPathComponent, mimeType: contentType)
                                }
                            } else if let value = param["value"] as? String {
                                multipartFormData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: paramName)
                            }
                        } else {
                            print("param incorrect")
                        }
                    }
            }, usingThreshold: 0,
               to: request.asFullUrl,
               headers: request.asFullHttpHeaders,
               encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    self.uploadRequest = upload
                    //                    upload.uploadProgress(closure: { (progress) in
                    //                        run(queue: responseQueue) {
                    //                            uploadProgress?(progress)
                    //                        }
                    //                    })
                    upload.responseJSON { data in
                        print(data)
                        completed(APIResponse(data, fromRequest: request))
                    }
                case .failure(let error): break
                let apiError = APIError.request(statusCode: nil, error: error)
                completed(APIResponse.error(apiError))
                }
            })
        case .multipartFile(let datas, let parameters, let name, let fileName, let mimeType):
            let fullHttpHeaders = prepareHeadersForMultipartOrBinary(request: request)
            Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let valueData = "\(value)".data(using: String.Encoding.utf8) {
                        multipartFormData.append(valueData, withName: key as String)
                    }
                }
                
                for (key, data) in datas.enumerated() {
                    if let data = data {
                        multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
                    }
                }
                
            }, usingThreshold: UInt64(), to: request.asFullUrl, method: request.method, headers: fullHttpHeaders) { (result) in
                switch result {
                case .success(let upload, _, _):
                    self.uploadRequest = upload.responseJSON { [weak self] data in
                        guard let sSelf = self else { return }
                        completed(APIResponse(data, fromRequest: request))
                        APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                        print("▶︎ [API Processing Manager] Removed multipart request from list for screen: \(sSelf.target?.name ?? "none") !")
                    }
                case .failure(let error):
                    let apiError = APIError.request(statusCode: nil, error: error)
                    completed(APIResponse.error(apiError))
                }
            }
        case let .download(file, _):
            let urlRequest = prepareBodyFor(request: request)

            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (file, [.removePreviousFile])
            }
            Alamofire.download(urlRequest, to: destination).downloadProgress(closure: {(progress) in
//                print("download progress = \(progress)")
            }).response(completionHandler: {[weak self] res in
                guard let sSelf = self else { return }
                if let error = res.error, let url = res.destinationURL, url.isExsist() {
                    let apiError = APIError.request(statusCode: nil, error: error)
                    completed(APIResponse.error(apiError))
                    return
                }
                completed(APIResponse.success(JSON.init(1)))
                APIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
            })
        }
    }
    
    // MARK: - Retry api task
    func retry() {
        guard let request = self.request, let completionHandler = self.completionHandler else { return }
        execute(request: request, completed: completionHandler)
    }
    
    // MARK: - Cancel api task
    func cancel() {
        if let dataRequest = self.dataRequest {
            dataRequest.cancel()
            self.dataRequest = nil
        }
        if let uploadRequest = self.uploadRequest {
            uploadRequest.cancel()
            self.uploadRequest = nil
        }
        APIProcessingManager.instance.removeDispatcherFromList(dispatcher: self)
    }
}

// MARK: - Prepare input data for requests
extension APIDispatcher {
    func prepareBodyFor(request: APIRequest) -> URLRequestConvertible {
        return ConvertibleRequest(request: request)
    }
    
    func prepareQuerryFor(request: APIRequest) throws -> URLRequest? {
        // Request url
        let enviroment = request.enviroment
        guard let url = URL(string: request.asFullUrl) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        // Method
        urlRequest.httpMethod = request.method.rawValue
        
        // Timeout interval
        urlRequest.timeoutInterval = enviroment.timeout
        
        // Http headers
        request.asFullHttpHeaders.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        // Parameters
        var parameters: Parameters = [:]
        switch request.parameters {
        case .querryString(let params):
            parameters = params
        default:
            break
        }
        let encodedURLRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)

        // Return result
        return encodedURLRequest
    }
    
    func prepareRawFor(request: APIRequest, rawText: String) -> URLRequest? {
        // Request url
        let enviroment = request.enviroment
        guard let url = URL(string: request.asFullUrl) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        // Method
        urlRequest.httpMethod = request.method.rawValue
        
        // Timeout interval
        urlRequest.timeoutInterval = enviroment.timeout
        
        // Http headers
        request.asFullHttpHeaders.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        // Raw text
        guard let textData = rawText.data(using: .utf8, allowLossyConversion: false) else { return nil }
        urlRequest.httpBody = textData
        
        // Return result
        return urlRequest
    }
    
    func prepareHeadersForMultipartOrBinary(request: APIRequest) -> HTTPHeaders {
        return request.asFullHttpHeaders
    }
}

struct ConvertibleRequest: URLRequestConvertible {
    
    private var request: APIRequest
    
    init(request: APIRequest) {
        self.request = request
    }
    
    func asURLRequest() throws -> URLRequest {
        // Request url
        let enviroment = request.enviroment
        var urlRequest = URLRequest(url: URL(string: request.asFullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!)
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        // Method
        urlRequest.httpMethod = request.method.rawValue
        
        // Timeout interval
        urlRequest.timeoutInterval = enviroment.timeout
        
        // Http headers
        request.asFullHttpHeaders.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        // Parameters
        var parameters: Parameters = [:]
        switch request.parameters {
        case .body(let params):
            parameters = params
        default:
            break
        }
        
        // Return result
        return try enviroment.encoding.encode(urlRequest, with: parameters)
    }
}
