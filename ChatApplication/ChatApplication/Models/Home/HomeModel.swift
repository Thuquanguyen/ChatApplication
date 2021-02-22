//
//  FravoriteDoctor.swift
//  YTeThongMinh
//
//  Created by DatTV on 5/30/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class FavoriteDoctor: NSObject {
    var doctorID: Int?
    var avatar = ""
    var name = ""
    var gender = ""
    var ranking: Double = 0
    var hospitalName = ""
    var specialty = ""
    var doctorAccountId: Int?
    var dateofbirth: String = ""
    var experienceYear: String = ""
    var workingProcess: String = ""
    var isVideoCall: Bool = false
    var isFavorite: Bool = false
    var doctorAppointmentAudio: Double = 0
    var doctorAppointmentVideo: Double = 0
    var doctorDirectAudio: Double = 0
    var doctorDirectVideo: Double = 0
    var academicShortName: String = ""
    var degreeShortName: String = ""
    var qualificationShortName: String = ""
    var qualificationName: String = ""

    var birthday: Date?

    init(json: JSON) {
        self.doctorID = json["doctor_id"].intValue
        self.avatar = json["avatar"].stringValue
        self.name = json["name"].stringValue
        self.gender = json["gender"].stringValue
        self.qualificationName = json["qualification"]["short_name"].stringValue
        self.ranking = (json["ranking"].doubleValue * 10).rounded() / 10
        self.hospitalName = json["hospital"]["name"].stringValue
        self.specialty = json["specialty"]["name"].stringValue
        self.doctorAccountId = json["account_id"].int
        self.dateofbirth = json["dateofbirth"].stringValue
        birthday = dateofbirth.dateBy(format: Constants.dateFormat)
        self.experienceYear = json["experience_year"].stringValue
        self.workingProcess = json["working_process"].stringValue
        self.isVideoCall = json["is_videocall_available"].boolValue
        self.isFavorite = json["isFavorite"].boolValue
        self.academicShortName = json["academic"]["short_name"].stringValue
        self.degreeShortName = json["degree"]["short_name"].stringValue
        self.qualificationShortName = json["qualification"]["name"].stringValue
        self.doctorAppointmentAudio = json["doctor_service_cost"]["appointment_audio"].doubleValue
        self.doctorAppointmentVideo = json["doctor_service_cost"]["appointment_video"].doubleValue
        self.doctorDirectAudio = json["doctor_service_cost"]["direct_audio"].doubleValue
        self.doctorDirectVideo = json["doctor_service_cost"]["direct_video"].doubleValue
    }
    
    override init() {
        
    }
}


class MeasurementDataHistory: BaseModel {
    var stringId: String?
    var patientId, time: String?
    var hr, bpSys, bpDia: Int?
    var pass: String?
    var color = UIColor.clear
    var detail: String?
    
    var diabetes: Int?
    var temperature: Int?
    
    var descriptions: [DescriptionBloodPressure] = []
    var bloodPressureType: BloodPressureType = .NONE
    
     // dataType: "TEXT" or "IMAGE"
    var dataType: String?
    
    var date: Date?
    var isChecked = false
    
    required init(json: JSON) {
        super.init()
        setupData(json: json)
    }
    
    required init() {
        super.init()
    }
    
    override func setupData(json: JSON) {
        let ids = json["id"].rawValue
        if let i = ids as? Int {
            self.id = i
        } else if let i = ids as? String {
            self.stringId = i
        }
        self.patientId = json["patient_id"].string
        self.time = json["time"].string
        self.hr = json["HR"].int
        self.bpSys = json["BP"]["systolic"].int
        self.bpDia = json["BP"]["diastolic"].int
        self.descriptions = json["description"].arrayValue.map{
            let item = DescriptionBloodPressure()
            item.isSelect = true
            item.setupData(json: $0)
            return item
        }
        bloodPressureType = BloodPressureType(rawValue: json["bp_category"].stringValue) ?? .NONE
        date = time?.dateBy(format: Constants.monitoringDateFormat, timeZone: Date.gmtTimeZone)
        self.dataType = json["data_type"].string
        pass = json["alert"]["pass"].string
        detail = json["alert"]["detail"].string
        color = UIColor(json["alert"]["color"].stringValue)
    }
    
    // type: "TEXT" or "IMAGE"
    func toParams(type: String = "TEXT") -> [String: Any] {
        var params: [String: Any] = [:]
        params["record_id"] = stringId
        params["patient_id"] = SharedData.userID
        var list: [DescriptionBloodPressure] = []
        for item in descriptions {
            if item.isSelect {
                list.append(item)
            }
        }
        params["description"] = list.map { $0.toParams() }
        params["hr"] = hr
        params["bp"] = ["systolic": bpSys, "diastolic": bpDia]
        params["data_type"] = type
        return params
    }
}

enum BloodPressureType: String {
    case LOW, GOOD, PRE, LV1, LV2, LV3, NONE
    
    var color: UIColor {
        switch self {
        case .LOW:
            return .blue
        case .GOOD:
            return #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
        case .PRE:
            return UIColor(r: 230, g: 230, b: 0)
        case .LV1:
            return .orange
        case .LV2:
            return #colorLiteral(red: 1, green: 0.2705882353, blue: 0, alpha: 1)
        case .LV3:
            return .red
        default:
            return #colorLiteral(red: 0.4352941176, green: 0.8274509804, blue: 0.8352941176, alpha: 1)
        }
    }
    
    var text: String? {
        switch self {
        case .LOW:
            return "Thấp"
        case .GOOD:
            return "Tốt"
        case .PRE:
            return "Tiền THA"
        case .LV1:
            return "Độ 1"
        case .LV2:
            return "Độ 2"
        case .LV3:
            return "Độ 3"
        default:
            return nil
        }
    }
    
    var textHome: String? {
        switch self {
        case .LOW:
            return "Thấp"
        case .GOOD:
            return "Tốt"
        case .PRE:
            return "Đạt huyết áp mục tiêu\nTiền THA"
        case .LV1:
            return "Không đạt huyết áp mục tiêu\nĐộ 1"
        case .LV2:
            return "Không đạt huyết áp mục tiêu\nĐộ 2"
        case .LV3:
            return "Không đạt huyết áp mục tiêu\nĐộ 3"
        default:
            return nil
        }
    }
}


class DescriptionBloodPressure: BaseModel {
    
    override func setupData(json: JSON) {
        id = json["measure_symptom_id"].intValue
        name = json["name"].stringValue
        if id == 1 {
            contentOther = name
        }
    }
    
    func toParams() -> [String: Any]  {
        var params: [String: Any] = [:]
        params["measure_symptom_id"] = id
        params["name"] = id == 1 ? contentOther : name
        return params
    }
}
