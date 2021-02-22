//
//  NotificationHandler.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 2/3/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

enum RemoteNotificationType {
    case thongTinTuChinhQuyen
    case thongTinKhanCap
    case thongTinChiDao
    case yKienNguoiDan
}

class NotificationHandler {
    // MARK: - Singleton
    static var instance = NotificationHandler()
    
    var isOpenAppFromRemoteNotifWhenAppInactive = true
    var isNeedNavigateRemoteNotif = false
}


// MARK: - Handle push notification & local notification data
extension NotificationHandler {
    /// Receive data from remote & handle navigate to specific screen
    /// - parameter userInfo: Payload data from notification
    
    func received(notification userInfo: [AnyHashable: Any], application: UIApplication, isRemoteNoti: Bool) {
        // emergency
        let json = JSON(userInfo)
        
        if isOpenAppFromRemoteNotifWhenAppInactive {
            //Store notif and open later
            isNeedNavigateRemoteNotif = true
            SharedData.remoteNotificationNeedOpening = userInfo
        } else {
            navigateNotiToApp(json: json)
        }
    }
    
    private func navigateNotiToApp(json: JSON) {
        let contentType = json["content_type"].stringValue
        let content_id = json["content_id"].intValue
        if content_id == 0 {
            return
        }
       
    }
    
    func prepareToNavigateSavedRemoteNotification(notification userInfo: [AnyHashable: Any]? = SharedData.remoteNotificationNeedOpening) {
        if let userInfo = userInfo, isNeedNavigateRemoteNotif {
            let json = JSON(userInfo)
            navigateNotiToApp(json: json)
            isNeedNavigateRemoteNotif = false
        }
    }
}
