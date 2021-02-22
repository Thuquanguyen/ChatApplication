//
//  APIConfiguration.swift
//  CTT_BN
//
//  Created by IchNV-D1 on 4/24/19.
//  Copyright © 2019 VietHD-D3. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

// MARK: - Request basic information
class APIConfiguration {
    
    //MARK: - Role App
    static let roleApp = "PATIENT"
    
    //MARK: - Port Base URL
    static var baseUrlPort: String {
        #if DEVELOP
        return "https://web-app-sever-2.herokuapp.com/"
        #else
        return "https://web-app-sever-2.herokuapp.com/"
        #endif
    }
    
    //MARK: - Main Base URL
    static var baseUrl: String {
        #if DEVELOP
        return "https://web-app-sever-2.herokuapp.com"
        #else
        return "https://web-app-sever-2.herokuapp.com"
        #endif
    }
    
    //MARK: - Additional Base URL
    
    // Text To Speech API
    static let cloudSttUrl = "https://speech.googleapis.com/v1" //Google API
    static let fbURL = "https://graph.fb.me/v8.0"
    
    // Chatbot API
    static let chatBotUrl =  ""
    
    #if DEVELOP
    static let chatBotMcdUrl = ""
    #else
    static let chatBotMcdUrl = ""
    #endif
    
    
    //MARK: - Custom Header
    
    // User Headers
    static var userHeaders: HTTPHeaders {
        var headers: HTTPHeaders = httpHeaders
        headers["Authorization"] = "Bearer " + (SharedData.accessToken ?? "")
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    // User Bearer Authorization Headers
    static var userBearerAuthorizationHeaders: HTTPHeaders {
        var headers: HTTPHeaders = httpHeaders
        headers["Authorization"] = "Bearer " + (SharedData.accessToken ?? "")
        return headers
    }
    
    // HTTP Headers
    static var httpHeaders: HTTPHeaders {
        return [:
//            "CLIENTAPIKEY": clientApiKey
        ]
    }
    
    // SR HTTP Headers
    static var srHeaders: HTTPHeaders {
        return ["api_key": Constants.openFptApiKey,
                "Content-Type": ""]
    }
    
    // TTS HTTP Headers
    static var ttsHeaders: HTTPHeaders {
        return ["api-key": Constants.openFptApiKey,
                "voice": SharedData.typeVoice.rawValue]
    }
    
    static var cloudsHeader: HTTPHeaders {
        return ["Content-Type" : "application/json","X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? ""]
    }
    
    static var chatBotHeader: HTTPHeaders {
        return ["Authorization": "Bearer \(Constants.chatBotTokenCode)"]
    }
    
    //MARK: - Main encoding
    static let encoding: ParameterEncoding = URLEncoding.default
    
    //MARK: - Set default timeout for each request
    static let timeout: TimeInterval = 20.0
    
    //MARK: - Client API key
    static var clientApiKey: String {
        #if DEVELOP || STAGING
        return ""
        #else
        return ""
        #endif
    }
    
    //MARK: - API Status Message
    struct APIStatusMessage {
        static let succeed = "succeed"
    }
    
    //MARK: - Setting API Request Global
    static let autoShowApiErrorAlert = false
    static let autoShowRequestErrorAlert = false
    static let autoShowNoNetWorkAlert = true
}



