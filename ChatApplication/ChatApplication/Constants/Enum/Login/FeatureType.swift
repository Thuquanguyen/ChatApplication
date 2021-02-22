//
//  FeatureType.swift
//  TetViet
//
//  Created by KienPT on 1/15/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
enum FeatureType {
    case smartReminder
    case favotire
    case horoscope
    case myTet
    
    var title: String {
        switch self {
        case .smartReminder:
            return "login_title_remind".localized
        case .favotire:
            return "login_title_favourite".localized
        case .horoscope:
            return "Tử vi"
        case .myTet:
            return "Tết của tôi"
        }
    }
    
    var content: String {
        switch self {
        case .smartReminder:
            return "login_describe_remind".localized
        case .favotire:
            return "login_describe_favourite".localized
        case .horoscope:
            return "Lập tức xem tử vi của mình và dễ dàng tra cứu cho người khác"
        case .myTet:
            return "Chọn nơi ăn tết và nhận những gợi ý xung quanh địa điểm đã chọn"
        }
    }
    
    var image: String {
        switch self {
        case .smartReminder:
            return "ic_login_ringtun"
        case .favotire:
            return "ic_login_bookmark"
        case .horoscope:
            return "ic_login_yinyang"
        case .myTet:
            return "ic_login_home_town"
        }
    }
}
