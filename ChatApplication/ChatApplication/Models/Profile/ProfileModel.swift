//
//  Profile.swift
//  YTeThongMinh
//
//  Created by DatTV on 6/3/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//


import UIKit
import SwiftyJSON

struct PatientModel {
    
    var patientId : Int?
    var identificationNumber : String?
    var address : String?
    var avatar : String?
    var city : String?
    var dateofbirth : String?
    var email : String?
    var gender : String?
    var height : NSDecimalNumber?
    var weight : NSDecimalNumber?
    var name : String?
    var phoneNumber : String?
    var age: Int?
    var dob: Date?
    var hospitalId: Int?
    var cityId: Int?
    var hospitalName: String?
    var cityName: String?
    var isBPDiagnose = false
    var bpOther: String?
    
    var birthday: Date? {
        didSet {
            dateofbirth = birthday?.stringBy(format: Constants.dateFormatS)
        }
    }
    
    var isMale: Bool {
        get {
            return gender == "MALE"
        }
        set(value) {
            gender = value ? "MALE" : "FEMALE"
        }
    }
    
    init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        address = json["address"].string
        avatar = json["avatar"].string
        email = json["email"].string
        gender = json["gender"].string
        height = NSDecimalNumber(string: json["height"].rawString())
        identificationNumber = json["identification_number"].string
        name = json["name"].string
        patientId = json["patient_id"].int
        phoneNumber = json["phone_number"].string
        weight = NSDecimalNumber(string: json["weight"].rawString())
        city = json["city"]["name"].string
        birthday = json["dateofbirth"].string?.dateBy(format: Constants.dateFormat)
        dateofbirth = birthday?.stringBy(format: Constants.dateFormatS)
        hospitalName = json["hospital"]["name"].stringValue
        hospitalId = json["hospital"]["hospital_id"].intValue
        cityName = json["city"]["name"].stringValue
        if let age = json["age"].int {
            self.age = age
        }
        isBPDiagnose = json["history_medical"]["is_bp_increase_diagnosed"].boolValue
    }
    
    init() {
    }
    
    func toParams() -> [String: Any] {
        var params: [String: Any] = [:]
        params["address"] = address
        params["dateofbirth"] = birthday?.stringBy(format: Constants.dateFormat)
        params["email"] = email.isEmpty ? nil : email
        params["gender"] = gender ?? "FEMALE"
        params["identification_number"] = identificationNumber
        params["name"] = name
        params["patient_id"] = patientId
        params["phone_number"] = phoneNumber.isEmpty ? nil : phoneNumber
        if let h = height, h.isNumeric, let w = weight, w.isNumeric {
            params["height"] = h
            params["weight"] = w
        }
        if let hospitalId = hospitalId {
            params["hospital_id"] = hospitalId
        }
        params["city_id"] = cityId
        var historyMedical: [String: Any] = [:]
        historyMedical["is_bp_increase_diagnosed"] = isBPDiagnose
        historyMedical["bp_other"] = bpOther
        params["history_medical"] = historyMedical
        return params
    }
}
