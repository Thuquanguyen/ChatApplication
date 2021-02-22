//
//  NotiCenterName.swift
//  TetViet
//
//  Created by vinhdd on 12/20/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit

class NotiCenterName {
    static let tapTabBarNotification = NSNotification.Name(rawValue: "TapTabBarNotification")
    static let refreshTabBarPersonalViewNotification = NSNotification.Name(rawValue: "RefreshTabBarPersonalViewNotification")
    static let tabBarChildViewDidSwitchNotification = NSNotification.Name(rawValue: "TabBarChildViewDidSwitchNotification")
    static let refreshPersonalViewNotification = NSNotification.Name(rawValue: "RefreshPersonalViewNotification")
    static let refreshMyTetNotification = NSNotification.Name(rawValue: "refreshMyTetNotification")
    static let refreshMyTetTimelineNotification = NSNotification.Name(rawValue: "refreshMyTetTimelineNotification")
    static let getHomeSlideNotification = NSNotification.Name(rawValue: "getHomeSlideNotification")
    static let refreshLoginNotification = NSNotification.Name(rawValue: "refreshLoginNotification")
    static let toTopTableViewTimeline = NSNotification.Name(rawValue: "toTopTableViewTimeline")
    static let sentenceTemplateSelected = NSNotification.Name(rawValue: "sentenceTemplateSelected")
    static let refreshHomeSearchAvatar = NSNotification.Name(rawValue: "refreshHomeSearchAvatar")
    static let logoutUser = NSNotification.Name(rawValue: "logoutUser")
    static let UnreadMessageChangeNotification = Notification.Name("UnreadMessageChangeNotification")
}
