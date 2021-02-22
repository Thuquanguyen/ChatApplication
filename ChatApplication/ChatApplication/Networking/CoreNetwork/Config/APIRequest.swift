//
//  APIRequest.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public enum APIParameterType {
    case body(_ parameters: Parameters)
    case querryString(_ parameters: Parameters)
    case raw(_ text: String)
    case multipart(datas: [Data?], parameters: Parameters, name: String, fileName: String, mimeType: String)
    case multipartWithCover(datas: [Data?], parameters: Parameters, name: String, fileName: String, mimeType: String, coverImage: String?)
    case multipartFile(datas: [Data?], parameters: Parameters, name: String, fileName: String, mimeType: String)
    case multiImageAndFile(photo: [Data?], fileData: [Data?], parameters: Parameters, image: String, imageName: String, imageType: String, filePrefix: String, fileName: [String], fileType: [String])
    case binary(_ data: Data)
    case upload( parameters: [[String:Any]])
    case multipartFilesAndParams(files: [String: [URL]], parameters: [String: Any])
    case multipartMultiImage(images: [APIUploadImage], parameters: [String: Any])
    case download(file: URL, parameters: Parameters)
}

// Request
public struct APIRequest {
    var enviroment: APIEnviroment
    var name: String
    var path: String
    var method: HTTPMethod
    var expandedHeaders: HTTPHeaders
    var parameters: APIParameterType
    
    var asFullUrl: String {
        if enviroment.baseUrl.isEmpty {
            return path
        }
        return enviroment.baseUrl + (!path.isEmpty ? "/" : "") + path
    }
    
    var asFullHttpHeaders: HTTPHeaders {
        var fullHeaders: HTTPHeaders = [:]
        enviroment.headers.forEach {
            fullHeaders[$0.key] = $0.value
        }
        expandedHeaders.forEach {
            fullHeaders[$0.key] = $0.value
        }
        return fullHeaders
    }
    
    init(name: String,
         path: String,
         method: HTTPMethod,
         expandedHeaders: HTTPHeaders = APIConfiguration.httpHeaders,
         parameters: APIParameterType,
         enviroment: APIEnviroment = APIEnviroment.default) {
        self.name = name
        self.path = path
        self.method = method
        self.expandedHeaders = expandedHeaders
        self.parameters = parameters
        self.enviroment = enviroment
    }
    
    func printInformation() {
        print("\n[Request API] ▶︎ [\(name)]")
        print("▶︎ Full url: \(asFullUrl)")
        print("▶︎ Method: \(method.rawValue)")
        print("▶︎ HTTP Headers:\n\(JSON(asFullHttpHeaders))")
        switch parameters {
        case .body(let params):
            print("▶︎ Parameters:\n\(JSON(params))")
        case .querryString(let params):
            print("▶︎ Parameters:\n\(JSON(params))")
        case .raw(let text):
            print("▶︎ Raw text:\n\(text)")
        case .multipart(let datas, let params, let name, let filename,let mimeType):
            print("▶︎ Data length: \(datas.count)\n")
            print("▶︎ Name: \(name)\n")
            print("▶︎ Filename: \(filename)\n")
            print("▶︎ MimeType: \(mimeType)\n")
            print("▶︎ Parameters:\n\(JSON(params))")
        case .binary(let data):
            print("▶︎ Data length: \(data.count)\n")
        case .upload:
            break
        case .multipartWithCover(let datas, let parameters, let name, let fileName, let mimeType, let coverImage):
            print("▶︎ Data length: \(datas.count)\n")
            print("▶︎ Name: \(name)\n")
            print("▶︎ Filename: \(fileName)\n")
            print("▶︎ CoverImage: \(coverImage ?? "")\n")
            print("▶︎ MimeType: \(mimeType)\n")
            print("▶︎ Parameters:\n\(JSON(parameters))")
            break
        case .multipartFile(let datas, let parameters, let name, let fileName, let mimeType):
            print("▶︎ Data length: \(datas.count)\n")
            print("▶︎ Name: \(name)\n")
            print("▶︎ Filename: \(fileName)\n")
            print("▶︎ MimeType: \(mimeType)\n")
            print("▶︎ Parameters:\n\(JSON(parameters))")
            break
        case .multiImageAndFile(let imageDatas, let fileDatas, let parameters, let image, let imageName, let imageType, let filePrefix, let fileName, let fileType):
            print("▶︎ Parameters:\n\(JSON(parameters))")
            print("▶︎ Data Photo length : \(imageDatas.count)\n")
            print("▶︎ Photo: \(image)\n")
            print("▶︎ Photo Name: \(imageName)\n")
            print("▶︎ Photo Type: \(imageType)\n")
            print("▶︎ Data File length : \(fileDatas.count)\n")
            print("▶︎ File: \(filePrefix)\n")
            print("▶︎ File Name: \(fileName)\n")
            print("▶︎ File Type: \(fileType)\n")
            break
        case .multipartFilesAndParams(_, _):
             break
        case .multipartMultiImage(images: let images, parameters: let parameters):
            print("▶︎ Parameters:\n\(JSON(parameters))")
            print("▶︎ Image count : \(images.count)\n")
            debugPrint("▶︎ File: \(images)\n")
        case .download(_, _):
            break
        }
    }
}

func print(_ items: Any...) {
    #if DEVELOP
//    items.forEach {
        Swift.print(items[0])
//    }
    #endif
}
