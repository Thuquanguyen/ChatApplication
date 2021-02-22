//
//  SocketConfiguration.swift
//  TetViet
//
//  Created by vinhdd on 12/17/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit

class SocketConfiguration {

    // Base wss
    static var wssUrl: String {
        var clientId = ""
        if let savedSenderId = SharedData.chatBotSenderId {
            clientId = savedSenderId
        } else {
            clientId = generateClientId()
            SharedData.chatBotSenderId = clientId
        }
        return "wss://bot.fpt.ai/ws/livechat" + "/" + Constants.chatBotAppCode + "/" + clientId + "/"
    }

    // MCD wss
    static var mcdWssUrl: String {
        var clientId = ""
        if let savedSenderId = SharedData.chatBotSenderId {
            clientId = savedSenderId
        } else {
            clientId = generateMcdClientId()
            SharedData.chatBotSenderId = clientId
        }
        return APIConfiguration.chatBotMcdUrl
    }
}

// MARK: - Supporting functions
extension SocketConfiguration {
    static func generateClientId() -> String {
        let baseRandomId = String.randomStringWith(type: .numericDigitsAndLetters, length: 20) + Constants.chatBotAppCode
        if let md5 = baseRandomId.md5 { return md5 }
        return baseRandomId
    }
    
    static func generateMcdClientId() -> String {
        let baseRandomId = String.randomStringWith(type: .numericDigitsAndLetters, length: 20) + Constants.chatBotMCDAppCode
        if let md5 = baseRandomId.md5 { return md5 }
        return baseRandomId
    }
}
