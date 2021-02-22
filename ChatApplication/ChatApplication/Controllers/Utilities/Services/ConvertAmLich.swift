//
//  ConvertAmLich.swift
//  ThuyTrieu2017
//
//  Created by Trung Kien on 1/15/18.
//  Copyright © 2018 Trung Kien. All rights reserved.
//
import Foundation
class ConvertAmLich {
    static let PI = Double.pi
    
    static func jdFromDate(dd: Int, mm: Int, yy: Int) -> Int{
        let a : Int = (14 - mm) / 12
        let y : Int = yy + 4800 - a
        let m : Int = mm + 12 * a - 3;
        var jd : Int = dd + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045
        if (jd < 2299161) {
            jd = dd + (153 * m + 2 ) / 5 + 365 * y + y / 4 - 32083
        }
        return jd
    }
    
    static func jdToDate(jd: Int) ->[Int]{
        var a, b, c : Int
        if (jd > 2299160) { // After 5/10/1582, Gregorian calendar
            a = jd + 32044
            b = (4*a+3)/146097
            c = a - (b*146097)/4
        } else {
            b = 0
            c = jd + 32082
        }
        let d : Int = (4*c+3)/1461
        let e : Int = c - (1461*d)/4
        let m : Int = (5*e+2)/153
        let day : Int = e - (153*m+2)/5 + 1
        let month : Int = m + 3 - 12*(m/10)
        let year : Int = b*100 + d - 4800 + m/10
        return  [day, month, year]
    }
    
    static func SunLongitude(jdn: Double) -> Double{
        return SunLongitudeAA98(jdn: jdn)
    }
    
    static func SunLongitudeAA98(jdn: Double) -> Double{
        let T : Double = (jdn - 2451545.0 ) / 36525 // Time in Julian centuries from 2000-01-01 12:00:00 GMT
        let T2: Double = T*T
        let dr : Double = PI/180; // degree to radian
        let M: Double = 357.52910 + 35999.05030*T - 0.0001559*T2 - 0.00000048*T*T2 // mean anomaly, degree
        let L0 : Double = 280.46645 + 36000.76983*T + 0.0003032*T2 // mean longitude, degree
        var DL: Double = (1.914600 - 0.004817*T - 0.000014*T2) * sin(dr*M)
        DL = DL + (0.019993 - 0.000101*T) * sin(dr*2*M) + 0.000290 * sin(dr*3*M)
        var L: Double = L0 + DL // true longitude, degree
        L = L - Double(360 * (INT(d:L/360))) // Normalize to (0, 360)
        return L
    }
    
    static func NewMoon(k: Int) -> Double{
        return NewMoonAA98(k: k)
    }
    
    static func NewMoonAA98(k: Int) -> Double{
        let T : Double = Double(k)/1236.85 // Time in Julian centuries from 1900 January 0.5
        let T2: Double = T * T
        let T3: Double = T2 * T
        let dr: Double = PI/180
        var Jd1 : Double = 2415020.75933 + 29.53058868 * Double(k) + 0.0001178 * T2 - 0.000000155 * T3
        Jd1 = Jd1 + 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * T2 ) * dr) // Mean new moon
        let M: Double = 359.2242 + 29.10535608 * Double(k) - 0.0000333 * T2 - 0.00000347 * T3 // Sun's mean anomaly
        let Mpr: Double = 306.0253 + 385.81691806 * Double(k) + 0.0107306 * T2 + 0.00001236 * T3 // Moon's mean anomaly
        let F: Double = 21.2964 + 390.67050646 * Double(k) - 0.0016528 * T2 - 0.00000239 * T3 // Moon's argument of latitude
        var C1 : Double = (0.1734 - 0.000393*T) * sin(M*dr) + 0.0021*sin(2*dr*M)
        C1 = C1 - 0.4068*sin(Mpr*dr) + 0.0161*sin(dr*2*Mpr)
        C1 = C1 - 0.0004*sin(dr*3*Mpr);
        C1 = C1 + 0.0104*sin(dr*2*F) - 0.0051*sin(dr*(M+Mpr))
        C1 = C1 - 0.0074*sin(dr*(M-Mpr)) + 0.0004*sin(dr*(2*F+M))
        C1 = C1 - 0.0004*sin(dr*(2*F-M)) - 0.0006*sin(dr*(2*F+Mpr))
        C1 = C1 + 0.0010*sin(dr*(2*F-Mpr)) + 0.0005*sin(dr*(2*Mpr+M))
        var deltat: Double
        if (T < -11) {
            deltat = 0.001 + 0.000839*T + 0.0002261*T2 - 0.00000845*T3 - 0.000000081*T*T3
        } else {
            deltat = -0.000278 + 0.000265*T + 0.000262*T2
        }
        let JdNew : Double = Jd1 + C1 - deltat
        return JdNew
    }
    static func INT(d: Double) -> Int{
        return Int(floor(d))
    }
    
    static func getSunLongitude(dayNumber: Int,timeZone: Double) -> Double {
        return SunLongitude(jdn: Double(dayNumber) - 0.5 - timeZone/24)
    }
    
    static func getNewMoonDay(k: Int, timeZone: Double) -> Int {
        let  jd: Double = NewMoon(k: k)
        return INT(d: jd + 0.5 + timeZone/24)
    }
    static func getLunarMonth11(yy: Int, timeZone: Double) -> Int {
        let  off : Double = Double(jdFromDate(dd: 31, mm: 12, yy: yy)) - 2415021.076998695
        let k: Int = INT(d: off / 29.530588853)
        var nm : Int = getNewMoonDay(k: k,timeZone: timeZone)
        let sunLong : Int = INT(d: getSunLongitude(dayNumber: nm, timeZone: timeZone)/30)
        if (sunLong >= 9) {
            nm = getNewMoonDay(k: k-1, timeZone: timeZone)
        }
        return nm
    }
    static func getLeapMonthOffset( a11: Int,  timeZone: Double) -> Int{
        let k: Int = INT(d: 0.5 + (Double(a11) - 2415021.076998695) / 29.530588853)
        var last: Int // Month 11 contains point of sun longutide 3*PI/2 (December solstice)
        var i: Int = 1; // We start with the month following lunar month 11
        var arc: Int = INT(d: getSunLongitude(dayNumber: getNewMoonDay(k: k+i, timeZone: timeZone), timeZone: timeZone)/30)
        repeat {
            last = arc
            i += 1
            arc = INT(d: getSunLongitude(dayNumber: getNewMoonDay(k: k+i, timeZone: timeZone), timeZone: timeZone)/30)
        } while (arc != last && i < 14);
        return i-1;
    }
    
    static func convertSolar2Lunar(date: Date, timeZone: Double) -> [Int] {
        guard let dd = date.getComponents().day, let mm = date.getComponents().month, let yy = date.getComponents().year else {
            return [-1,-1,-1]
        }
        var lunarDay, lunarMonth, lunarYear: Int
        let dayNumber: Int = jdFromDate(dd: dd, mm: mm, yy: yy)
        let k: Int = Int(Double(INT(d: Double(dayNumber) - 2415021.076998695)) / 29.530588853)
        var monthStart = getNewMoonDay(k: Int(k+1), timeZone: timeZone)
        if (monthStart > dayNumber) {
            monthStart = getNewMoonDay(k: k, timeZone: timeZone)
        }
        var a11 : Int = getLunarMonth11(yy: yy, timeZone: timeZone)
        var b11 : Int = a11
        if (a11 >= monthStart) {
            lunarYear = yy;
            a11 = getLunarMonth11(yy: yy-1, timeZone: timeZone)
        } else {
            lunarYear = yy+1;
            b11 = getLunarMonth11(yy: yy+1, timeZone: timeZone)
        }
        lunarDay = dayNumber - monthStart + 1
        let diff : Int = INT(d: Double((monthStart - a11)/29))
        lunarMonth = diff + 11
        if (b11 - a11 > 365) {
            let leapMonthDiff: Int = getLeapMonthOffset(a11: a11, timeZone: timeZone);
            if (diff >= leapMonthDiff) {
                lunarMonth = diff + 10
            }
        }
        if (lunarMonth > 12) {
            lunarMonth = lunarMonth - 12
        }
        if (lunarMonth >= 11 && diff < 4) {
            lunarYear -= 1
        }
        let Ngay : Int =  (lunarDay)
        let  Thang : Int  =  (lunarMonth)
        let Nam: Int  =  (lunarYear)
        
        return [Ngay, Thang, Nam]
    }
    
    static func convertLunar2Solar( lunarDay: Int, lunarMonth: Int,  lunarYear: Int,  lunarLeap: Int, timeZone: Double) -> [Int]{
        var a11, b11: Int
        if (lunarMonth < 11) {
            a11 = getLunarMonth11(yy: lunarYear-1, timeZone: timeZone)
            b11 = getLunarMonth11(yy: lunarYear, timeZone: timeZone)
        } else {
            a11 = getLunarMonth11(yy: lunarYear, timeZone: timeZone)
            b11 = getLunarMonth11(yy: lunarYear+1, timeZone: timeZone)
        }
        let k: Int = INT(d: 0.5 + (Double(a11) - 2415021.076998695) / 29.530588853)
        var off: Int = lunarMonth - 11
        if (off < 0) {
            off += 12
        }
        if (b11 - a11 > 365) {
            let leapOff: Int = getLeapMonthOffset(a11: a11, timeZone: timeZone);
            var leapMonth: Int = leapOff - 2;
            if (leapMonth < 0) {
                leapMonth += 12;
            }
            if (lunarLeap != 0 && lunarMonth != leapMonth) {
                
                return [0,0,0]
            } else if (lunarLeap != 0 || off >= leapOff) {
                off += 1
            }
        }
        let monthStart = getNewMoonDay(k: k+off, timeZone: timeZone);
        return jdToDate(jd: monthStart+lunarDay-1)
    }
}
