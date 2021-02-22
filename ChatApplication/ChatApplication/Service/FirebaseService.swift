//
//  FirebaseService.swift
//  TetViet
//
//  Created by QuangLH on 1/17/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
import FirebaseMessaging

class FirebaseService {
    static let shared = FirebaseService()
    
    private init() {}
    
    // subscribe a topic
    func subscribeTopic(topic: FirebaseTopicType) {
        for other in topic.otherTopicsUnsubscribe {
            unsubscribeTopic(topic: other)
        }
        Messaging.messaging().subscribe(toTopic: topic.rawValue)
    }
    
    // unsubscribe a topic
    func unsubscribeTopic(topic: FirebaseTopicType) {
        Messaging.messaging().unsubscribe(fromTopic: topic.rawValue)
    }
    
    // subscribe when login and register succeed
    func subscribeUser(birthday: Date?, gender: Gender?) {
        unsubcribeAllTopic()
        subscribeDefaultTopic()
        if let age = birthday?.currentAge {
           subscribeTopic(topic: FirebaseTopicType(age: age))
        }
        if let gender = gender {
            subscribeTopic(topic: FirebaseTopicType(gender: gender))
        }
    }
    
    // unsubscribe all topic when logout
    func unsubcribeAllTopic() {
        let allTopic: [FirebaseTopicType] = [.male, .female, .less18, .less40, .less50, .greater50, .ios, .rikkei]
        for topic in allTopic {
            unsubscribeTopic(topic: topic)
        }
        subscribeDefaultTopic()
    }
    
    // subscribe default topics
    func subscribeDefaultTopic() {
        subscribeTopic(topic: .ios)
        #if DEVELOP || STAGING
        subscribeTopic(topic: .rikkei)
        #endif
    }
    
    func getFirebaseToken() -> String? {
        let token = Messaging.messaging().fcmToken
        return token
    }
}
