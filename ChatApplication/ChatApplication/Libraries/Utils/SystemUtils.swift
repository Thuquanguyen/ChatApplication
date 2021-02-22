//
//  SystemInfo.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 10/29/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

// MARK: - App general information
class SystemUtils {
    
    static let screenBounds = UIScreen.main.bounds
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let screenNativeBounds = UIScreen.main.nativeBounds
    static let screenNativeWidth = UIScreen.main.nativeBounds.width
    static let screenNativeHeight = UIScreen.main.nativeBounds.height
    
    static var safeAreaInsetBottom: CGFloat {
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0
    }
    
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let schemeName = ProcessInfo.processInfo.environment["targetName"] ?? ""
    static let osName = UIDevice.current.systemName
    static let osVersion = UIDevice.current.systemVersion
    static let uuid = UUID().uuidString
    static var bundleId: String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    static let appIdOnAppStore: String = "" // Replace with app id on AppstoreConnect
    static var appUrlOnAppStore: URL? {
        let urlStr = String(format: "itms-apps://itunes.apple.com/app/bars/id%@", appIdOnAppStore)
        return URL(string: urlStr)
    }
}

// MARK: - Encoding
extension SystemUtils {
    static let shiftJISEncoding = String.Encoding.shiftJIS
    static let utf8Encoding = String.Encoding.utf8
}
