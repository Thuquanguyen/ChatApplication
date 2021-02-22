//
//  NotificationModel.swift
//  TetViet
//
//  Created by Datt-D1 on 4/18/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationModel {
    var id: Int = 1
    var createdAt: String = ""
    var topicId: Int = 1
    var topicTitle: String = ""
    
    var categoryId: Int = 1
    var categoryName: String = ""
    var contentType: String = ""
    var coverUrl: String = ""
    
    var latitude: String = ""
    var longitude: String = ""
    var viewQuantity: Int = 0
    var addressDetail: String = ""
    
    var dateStart: String = ""
    var timeStart: String = ""
    var dateEnd: String = ""
    var timeEnd: String = ""
    
    var deleted: Bool = false
    var noticeTitle: String = ""
    var noticeMessage: String = ""
    
    var cardType: String = ""
    var cardValue: String = ""
    var cardSerial: String = ""
    var cardCode: String = ""
    
    var personal: Int = 0
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.createdAt = json["created_at"].stringValue
        self.topicId = json["topic_id"].intValue
        self.topicTitle = json["topic_title"].stringValue
        
        self.categoryId = json["category_id"].intValue
        self.categoryName = json["category_name"].stringValue
        self.contentType = json["content_type"].stringValue
        self.coverUrl = json["cover_url"].stringValue
        
        self.latitude = json["latitude"].stringValue
        self.longitude = json["longitude"].stringValue
        self.viewQuantity = json["view_quantity"].intValue
        self.addressDetail = json["address_detail"].stringValue
        
        self.dateStart = json["date_start"].stringValue
        self.timeStart = json["time_start"].stringValue
        self.dateEnd = json["date_end"].stringValue
        self.timeEnd = json["time_end"].stringValue
        
        self.deleted = json["deleted"].boolValue
        
        self.noticeTitle = json["notice_title"].stringValue
        self.noticeMessage = json["notice_message"].stringValue
        
        self.cardType = json["card_type"].stringValue
        self.cardValue = json["card_value"].stringValue
        self.cardSerial = json["card_serial"].stringValue
        self.cardCode = json["card_code"].stringValue
        
        self.personal = json["personal"].intValue
        
    }
}
