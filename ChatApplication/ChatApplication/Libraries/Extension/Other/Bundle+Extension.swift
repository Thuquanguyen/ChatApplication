//
//  Bundle+Extension.swift
//  AICPeople-DEV
//
//  Created by TrungHD-D1 on 12/24/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var bundleName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
    
    var googleServiceInfoPlistFilePath: String? {
        #if DEVELOP
        return path(forResource: "GoogleService-Info", ofType: "plist")
        #elseif PRODUCT
        return path(forResource: "GoogleService-Info-PROD", ofType: "plist")
        #else
        return path(forResource: "GoogleService-Info-STORE", ofType: "plist")
        #endif
    }
}

