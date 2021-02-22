//
//  EnumType.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Gender: String {
    case male = "male"
    case female = "female"
    case unknow = "unknow"
    
    var value: String { return rawValue }
}

enum FPTSpeechVoiceType: String {
    case northMale = "male"
    case northFemale = "female"
    case middleFemale = "ngoclam"
    case southFemale = "hatieumai"
    
    var value: String { return rawValue }
    
    var text: String {
        switch self {
        case .northMale: return "giọng miền bắc"
        case .northFemale: return "giọng miền bắc"
        case .middleFemale: return "giọng miền trung"
        case .southFemale: return "giọng miền nam"
        }
    }
}

enum TypeVoice: String {
    case southMale = "sg_male_xuankien_vdts_48k-hsmm"
    case southFemale = "sg_female_xuanhong_vdts_48k-hsmm"
    case northMale = "hn_male_xuantin_vdts_48k-hsmm"
    case northFemale = "hn_female_thutrang_vdts_48k-hsmm"
}

enum TypeLanguage: String {
    case vn = "vi"
    case en = "en"
    case ja = "ja"
    case fr = "fr"
    
    var name: String {
        switch self {
        case .vn:
            return "VI"
        case .en:
            return "EN"
        case .ja:
            return "JA"
        default:
            return "FR"
        }
    }
    
    var image: String {
        switch self {
        case .vn:
            return "0"
        case .en:
            return "1"
        case .ja:
            return "2"
        default:
            return "3"
        }
    }
}

enum LoginType: String {
    case facebook = "facebook"
    case zalo = "zalo"
    case google = "google"
    case apple = "apple"
}

//enum UserCallingAcion {
//    case answer
//    case end
//    case mute
//    case speaker
//    case video
//    case switchCamera
//}
//
//enum UserCallingState {
//    case caller(CallerState)
//    case receiver(ReceiverState)
//    case normal
//    
//    var isNormal: Bool {
//        switch self {
//        case .normal: return true
//        default: return false
//        }
//    }
//    
//    enum CallerState {
//        case calling
//        case ringing
//        case busy
//        case answered
//        case end
//    }
//    
//    enum ReceiverState {
//        case waiting
//        case answered
//        case end
//    }
//}

// Just for testing
enum UserType: String {
    case outgoing
    case incoming
    
    var name: String {
        switch self {
        case .outgoing:
            return "phuongzzz_outgoing"
        case .incoming:
            return "phuongzzz_incoming"
        }
    }
    
    var token: String {
        switch self {
        case .outgoing:
            return "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTS1ZoMGR3ZzNuQnFoSFU0Z0F1TUQxUHl4MDk3b1gxTEstMTU5MDcyNTExMyIsImlzcyI6IlNLVmgwZHdnM25CcWhIVTRnQXVNRDFQeXgwOTdvWDFMSyIsImV4cCI6MTU5MzMxNzExMywidXNlcklkIjoibmFtcGh1b25nX2NhbGxpbmdvdXQifQ.wN7aGWviIb_oXIC8q-4I4Vad6_yrYgSCEhtkK8uX7NE"
        case .incoming:
            return "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTS1ZoMGR3ZzNuQnFoSFU0Z0F1TUQxUHl4MDk3b1gxTEstMTU5MDcyNTA4NyIsImlzcyI6IlNLVmgwZHdnM25CcWhIVTRnQXVNRDFQeXgwOTdvWDFMSyIsImV4cCI6MTU5MzMxNzA4NywidXNlcklkIjoibmFtcGh1b25nX2luY29tbWluZyJ9.kht7-bq3FADEPQeX5esShCEi5Pvrg4n4Uoxq1RsmSNc"
        }
    }
}


