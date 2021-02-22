//
//  DoiCanChi.swift
//  ThuyTrieu2017
//
//  Created by Trung Kien on 1/28/18.
//  Copyright © 2018 Trung Kien. All rights reserved.
//

import Foundation
import UIKit

class DoiCanChi{
    static let listCanNam = ["Giáp","Ất","Bính","Đinh","Mậu","Kỷ","Canh","Tân","Nhâm","Quý"]
    static let listChiNam = ["Tý","Sửu","Dần","Mão","Thìn","Tỵ","Ngọ","Mùi","Thân","Dậu","Tuất","Hợi"]
    static let listCanThang = ["Giáp","Ất","Bính","Đinh","Mậu","Kỷ","Canh","Tân","Nhâm","Quý"]
    static let listChiThang = ["Sửu","Dần","Mão","Thìn","Tỵ","Ngọ","Mùi","Thân","Dậu","Tuất","Hợi","Tý"]
    
    static let dateFormat = "yyyy/MM/dd"
    static let dateTimeFormat = "yyyy/MM/dd HH:mm:ss"
    static let birthdayDateFormat = "yyyy/MM"
    static let timeFormat = "HH:mm"
    
    static func conertNamCanChi(nam: Int) -> String {
        let can = (nam + 6) % 10
        let chi = (nam + 8) % 12
        return listCanNam[can] + " " + listChiNam[chi]
    }
    
    static func convertThangCanChi(thang : Int, nam : Int) -> String {
        let can = (nam * 12 + thang + 3) % 10
        let chi = thang % 12
        return listCanThang[can] + " " + listChiThang[chi]
    }
    
    static func convertNgayCanChi(day : Int, moth : Int, year: Int) -> String {
        let N = ConvertAmLich.jdFromDate(dd: day, mm: moth, yy: year)
        let can = Int(Double(N) + 9.5) % 10
        let chi = (N + 1) % 12
        return listCanNam[can] + " " + listChiNam[chi]
    }
    
    static func convertSunToCanChiLunaYear(birth: Date) -> String {
        let lunaData = ConvertAmLich.convertSolar2Lunar(date: birth, timeZone: Constants.vnTimezone)
        return conertNamCanChi(nam: lunaData[2])
    }
    
    static func displayThang(thang: Int) -> String {
        switch thang {
        case 1:
            return "month_of_year_jan".localized
        case 2:
            return "month_of_year_feb".localized
        case 3:
            return "month_of_year_mar".localized
        case 4:
            return "month_of_year_apr".localized
        case 5:
            return "month_of_year_may".localized
        case 6:
            return "month_of_year_jun".localized
        case 7:
            return "month_of_year_jul".localized
        case 8:
            return "month_of_year_aug".localized
        case 9:
            return "month_of_year_sep".localized
        case 10:
            return "month_of_year_oct".localized
        case 11:
            return "month_of_year_nov".localized
        case 12:
            return "month_of_year_dec".localized
        default:
            return ""
        }
    }
    
    static func displayThangHome(thang: Int) -> String {
        switch thang {
        case 1:
            return "home_month_of_year_jan".localized
        case 2:
            return "home_month_of_year_feb".localized
        case 3:
            return "home_month_of_year_mar".localized
        case 4:
            return "month_of_year_apr".localized
        case 5:
            return "home_month_of_year_may".localized
        case 6:
            return "home_month_of_year_jun".localized
        case 7:
            return "home_month_of_year_jul".localized
        case 8:
            return "home_month_of_year_aug".localized
        case 9:
            return "home_month_of_year_sep".localized
        case 10:
            return "home_month_of_year_oct".localized
        case 11:
            return "home_month_of_year_nov".localized
        case 12:
            return "home_month_of_year_dec".localized
        default:
            return ""
        }
    }
    
    static func displayThangHomeDuong(thang: Int) -> String {
        switch thang {
        case 1:
            return "home_month_of_year_jan".localized
        case 2:
            return "home_month_of_year_feb".localized
        case 3:
            return "home_month_of_year_mar".localized
        case 4:
            return "month_of_year_apr".localized
        case 5:
            return "home_month_of_year_may".localized
        case 6:
            return "home_month_of_year_jun".localized
        case 7:
            return "home_month_of_year_jul".localized
        case 8:
            return "home_month_of_year_aug".localized
        case 9:
            return "home_month_of_year_sep".localized
        case 10:
            return "home_month_of_year_oct".localized
        case 11:
            return "home_month_of_year_nov".localized
        case 12:
            return "home_month_of_year_dec".localized
        default:
            return ""
        }
    }
    
    static func setWeekDay(day: Int) -> String {
        switch day {
        case 1:
            return "weekday_day_sun".localized
        case 2:
            return "weekday_day_mon".localized
        case 3:
            return "weekday_day_tue".localized
        case 4:
            return "weekday_day_wed".localized
        case 5:
            return "weekday_day_thu".localized
        case 6:
            return "weekday_day_fri".localized
        case 7:
            return "weekday_day_sat".localized
        default:
            return ""
        }
    }
}
