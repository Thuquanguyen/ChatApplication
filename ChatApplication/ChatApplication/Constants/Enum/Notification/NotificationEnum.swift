//
//  NotificationEnum.swift
//  Develop
//
//  Created by Datt-D1 on 4/1/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

enum EnumNotifications {
    case notice
    case event
    case noticeCulture
    case noticeArticle
    case noticeStory
    
    var sectionNumber: Int {
        switch self {
        case .notice:
            return 0
        case .event:
            return 1
        case .noticeCulture:
            return 2
        case .noticeArticle:
            return 3
        case .noticeStory:
            return 4
        }
    }
    
    var contentType: String {
        switch self {
        case .notice:
            return "notice"
        case .event:
            return "Sắp đến một sự kiện bạn đã lưu"
        case .noticeCulture:
            return "notice_culture"
        case .noticeArticle:
            return "notice_article"
        case .noticeStory:
            return "notice_story"
        }
    }
}
