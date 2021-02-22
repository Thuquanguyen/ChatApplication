//
//  StringExtensions.swift
//  CTT_BN
//
//  Created by IchNV-D1 on 4/23/19.
//  Copyright © 2019 VietHD-D3. All rights reserved.
//

import Foundation



extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var jsonString: String? {
        if let dict = (self as AnyObject) as? Dictionary<String, AnyObject> {
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                if let string = String(data: data, encoding: String.Encoding.utf8) {
                    return string
                }
            } catch {
                print(error)
            }
        }
        return nil
    }
}


extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
//    var isAlphanumeric: Bool {
//        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
//    }
    
    var isValidQuery: Bool {
        return self.isEmpty || self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let phoneRegEx = "^((\\+84)|(84)|(0))[0-9]{9,10}$"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    func stringFromCurrency() -> String{
        let price = NSNumber.init(value: Double.init(self)!)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "vi_VN")
        
        if abs(price.doubleValue) > 1000000000{
            let pri = price.doubleValue / 1000000000
            return " \(round(pri * 1000)/1000) tỷ"
        } else if abs(price.doubleValue) > 10000000 {
            let pri = price.doubleValue / 1000000
            return " \(round(pri * 1000)/1000) triệu"
        }
        
        return formatter.string(from: price)!
    }
    
    func getImageRatioHeightWidthFromURL() -> Double {
        return 1.0
    }
}
