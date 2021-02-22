//
//  AppUtils.swift
//  YTeThongMinh
//
//  Created by PhuongTHN on 5/29/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import UIKit

class AppUtils: NSObject {
    static func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
