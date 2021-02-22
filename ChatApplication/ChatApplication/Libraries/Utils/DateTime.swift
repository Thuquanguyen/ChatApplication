//
//  DateTime.swift
//  YTeThongMinh
//
//  Created by ThuNQ on 6/1/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation

func convertDate(dateTime: String) -> String{
    let date = dateTime.split(separator: "-")
    return "\(date[2])/\(date[1])/\(date[0])"
}

func validateTime(timeFrom: String, timeTo: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    dateFormatter.locale = Locale.init(identifier: "en_GB")
    let dateFrom = dateFormatter.date(from: timeFrom) ?? Date()
    let dateTo = dateFormatter.date(from: timeTo) ?? Date()
    
    return daysBetween(start: dateFrom, end: dateTo)
}

func daysBetween(start: Date, end: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: start, to: end).day!
}

func convertDateInt64ToString(milliseconds:Int64) -> String {
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "dd/MM/YYYY hh:mm a"
    let dateString = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000))
    
    return dateString
}

func getCustomDateFormat(milliseconds:Int64) -> String {
    let monthDateFormatter = DateFormatter()
    monthDateFormatter.dateFormat = "d/M"
    let monthDateString = "ngày " + monthDateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000))
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    let timeString = timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000))
    
    return timeString + ", " + monthDateString
}

func countTimeToString(count : Int) -> String {
    switch count {
    case 0:
        return "Hôm nay"
    case 1:
        return "Hôm qua"
    case 2:
        return "2 ngày trước"
    case 3:
        return "3 ngày trước"
    default:
        return ""
    }
}

func convertMonthStringToInt(month: String) -> Int{
    switch month {
    case "Jan":
        return 1
    case "Feb":
        return 2
    case "Mar":
        return 3
    case "Apr":
        return 4
    case "May":
        return 5
    case "Jun":
        return 6
    case "Jul":
        return 7
    case "Aug":
        return 8
    case "Sep":
        return 9
    case "Oct":
        return 10
    case "Nov":
        return 11
    case "Dec":
        return 12
    default:
        return 1
    }
}
