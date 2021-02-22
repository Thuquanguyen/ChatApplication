//
//  SharedData.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: - General information
class SharedData {

    // Access token for requesting APIs
    class var accessToken: String? {
        get {
            return (UserDefaults.standard.value(forKey: "AccessToken") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "AccessToken")
        }
    }
    
    class var publicServiceToken: String? {
        get {
            return (UserDefaults.standard.value(forKey: "PublicServiceToken") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "PublicServiceToken")
        }
    }
    
    class var userID: Int? {
        get {
            return (UserDefaults.standard.value(forKey: "userID") as? Int)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "userID")
        }
    }
    
    // language App
    class var languageApp: String? {
        get {
            return (UserDefaults.standard.value(forKey: "LanguageApp") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "LanguageApp")
        }
    }
    
    // Phone user
    class var phonelUser: String? {
        get {
            return (UserDefaults.standard.value(forKey: "UserPhoneNumber") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "UserPhoneNumber")
        }
    }
    
    // Email user
    class var emailUser: String? {
        get {
            return (UserDefaults.standard.value(forKey: "UserEmail") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "UserEmail")
        }
    }
    
    // Avatar user
    class var avatarUser: UIImage? {
        get {
            let fileImage = FileManagerUtils.createCacheFile(fileName: FileManagerUtils.avatarFileName)!
            if fileImage.isExsist() {
                return UIImage(contentsOfFile: fileImage.path)
            }
            return nil
        }
        set(value) {
            let fileImage = FileManagerUtils.createCacheFile(fileName: FileManagerUtils.avatarFileName)!
            _ = fileImage.removeFile()
            if let data = value?.pngData() {
                _ = FileManagerUtils.createCacheFile(fileName: FileManagerUtils.avatarFileName, data: data)
            }
        }
    }
    
    // Phone user
    class var loginName: String? {
        get {
            return (UserDefaults.standard.value(forKey: "LoginName") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "LoginName")
        }
    }
    
    // Phone user
    class var accountId: Int? {
        get {
            return (UserDefaults.standard.value(forKey: "AccountId") as? Int)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "AccountId")
        }
    }
    
    // Fresh token User
    class var freshToken: String? {
        get {
            return (UserDefaults.standard.value(forKey: "FreshToken") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "FreshToken")
        }
    }
    
    // APNS token is saved in app
    class var deviceToken: String? {
        get {
            return (UserDefaults.standard.value(forKey: "NotificationToken") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "NotificationToken")
        }
    }
    
    // Chat Bot sender id
    static var chatBotSenderId: String? {
        get {
            return UserDefaults.standard.value(forKey: "ChatBotSenderId") as? String
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "ChatBotSenderId")
        }
    }
    
    // ChatBot speech voice type
    class var chatBotSpeechVoiceType: FPTSpeechVoiceType {
        get {
            if UserDefaults.standard.value(forKey: "ChatBotSpeechVoiceType") == nil {
                let defaultType = FPTSpeechVoiceType.northFemale
                UserDefaults.standard.set(defaultType.value, forKey: "ChatBotSpeechVoiceType")
                return defaultType
            }
            return FPTSpeechVoiceType(rawValue: UserDefaults.standard.value(forKey: "ChatBotSpeechVoiceType") as? String ?? "") ?? .northFemale
        }
        set(value) {
            UserDefaults.standard.set(value.value, forKey: "ChatBotSpeechVoiceType")
        }
    }
    
    // Chat Bot should say welcome
    class var chatBotShouldSayWelcome: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "ChatBotShouldSayWelcome") as? Bool) ?? false
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "ChatBotShouldSayWelcome")
        }
    }
    
    // VOICE saved in app
    class var typeVoice: TypeVoice {
        get {
            guard let type = UserDefaults.standard.value(forKey: "TypeVoice") as? String else {
                return TypeVoice.northFemale
            }
            return TypeVoice(rawValue: type) ?? TypeVoice.northFemale
        }
        set(value) {
            UserDefaults.standard.set(value.rawValue, forKey: "TypeVoice")
        }
    }
    
    // Save speech speed for chatbot
    class var speechSpeed: SpeechSpeedType {
        get {
            return SpeechSpeedType(speed: UserDefaults.standard.value(forKey: "speechSpeed") as? Float ?? 0)
        }
        set(value) {
            UserDefaults.standard.set(value.value, forKey: "speechSpeed")
        }
    }
    
    //First launched
    class var didFirstLaunched: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "didFirstLaunched") as? Bool) ?? false
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "didFirstLaunched")
        }
    }
    
    // First Send Location
    class var firstSendLocation: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "FirstSendLocation") as? Bool) ?? false
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "FirstSendLocation")
        }
    }
    
    // Audio Key
    class var audioKey: String? {
        get {
            return UserDefaults.standard.value(forKey: "audioKey") as? String
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "audioKey")
        }
    }

    class var emergencyCall: [String: String]? {
        get {
            return UserDefaults.standard.value(forKey: "emergencyCall") as? [String: String]
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "emergencyCall")
        }
    }

    class var firstTaxiInfo: [String: String]? {
        get {
            return UserDefaults.standard.value(forKey: "firstTaxiInfo") as? [String: String]
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "firstTaxiInfo")
        }
    }

    class var secondTaxiInfo: [String: String]? {
        get {
            return UserDefaults.standard.value(forKey: "secondTaxiInfo") as? [String: String]
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "secondTaxiInfo")
        }
    }

    class var firstBikeInfo: [String: String]? {
        get {
            return UserDefaults.standard.value(forKey: "firstBikeInfo") as? [String: String]
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "firstBikeInfo")
        }
    }

    class var secondBikeInfo: [String: String]? {
        get {
            return UserDefaults.standard.value(forKey: "secondBikeInfo") as? [String: String]
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "secondBikeInfo")
        }
    }
    
    class var oldAppVersion: String? {
        get {
            return UserDefaults.standard.string(forKey: "oldAppVersion")
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "oldAppVersion")
        }
    }
    
    class var remoteNotificationNeedOpening: [AnyHashable: Any]? {
        get {
            return UserDefaults.standard.value(forKey: "remoteNotificationNeedOpening") as? [AnyHashable: Any]
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "remoteNotificationNeedOpening")
        }
    }
    
    class var voipDeviceToken: String? {
        get {
            return UserDefaults.standard.value(forKey: "voipDeviceToken") as? String
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "voipDeviceToken")
        }
    }

    static func getUserData() -> PatientModel? {
        if let str = UserDefaults.standard.value(forKey: "UserData") as? String {
            return PatientModel(fromJson: JSON(parseJSON: str))
        }
        return nil
    }
    
    static func setUserData(json: JSON?) {
        UserDefaults.standard.set(json?.rawString(), forKey: "UserData")
    }
}
