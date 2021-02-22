//
//  String+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
import CommonCrypto

// General enum list
enum RandomStringType: String {
    case numericDigits = "0123456789"
    case uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    case allKindLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case numericDigitsAndLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    var text: String { return rawValue }
}

extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        return self == nil || self?.trimWhiteSpacesAndNewLines == ""
    }
}

extension String {
    
    func toJson() -> Any? {
        guard let data = self.data(using: .utf8) else {
            print("Error when parse String to data!")
            return nil
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return json
        } catch let error {
            print("Error : \(error)")
            return nil
        }
    }
    
    func verifyUrl() -> Bool {
        if let url = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    // MARK: - Subscript
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    // MARK: - Variables
    var int: Int? {
        return Int(self)
    }
    
    var double: Double? {
        return Double(self)
    }
    
    
    var url: URL? {
        return URL(string: self)
    }
    
    var image: UIImage? {
        return UIImage(named: self)
    }
    
    var localized: String {
        let languageCode = SharedData.languageApp ?? "vi"
        let bundle = Bundle.main.path(forResource: languageCode, ofType: "lproj")  ?? "vi"
        return NSLocalizedString(self, bundle: Bundle(path: bundle) ?? Bundle.main, comment: self)
    }
    
    var percentEncoding: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var trimWhiteSpaces: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var trimNewLines: String {
        return self.trimmingCharacters(in: .newlines)
    }
    
    var trimWhiteSpacesAndNewLines: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var md5: String? {
        guard let messageData = self.data(using:.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
    
    var hasSpecialCharacters: Bool {
        let regex = "(?=.*[A-Za-z0-9]).{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var isNumeric: Bool {
        return Double(self) != nil
    }
    
    var isEmail: Bool {
        let regex = "^(([\\w+-]+\\.)+[\\w+-]+|([a-zA-Z+]{1}|[\\w+-]{2,}))@((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        if self.contains("-") || self.contains("*") || self.contains("+") {
            let precidate = NSPredicate(format: "SELF MATCHES %@", "^((\\+)|(00))[0-9]{6,14}$")
            return precidate.evaluate(with: self)
        }
        let precidate = NSPredicate(format: "SELF MATCHES %@", "([0-9]){10,11}$")
        return precidate.evaluate(with: self)
    }
    
    var isLetter: Bool {
        return replacingOccurrences(of: " ", with: "").rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    var isAlphanumeric: Bool {
        return replacingOccurrences(of: " ", with: "").rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }
    
    /*
     * Minimum 6 and Maximum 30 characters Uppercase Alphabet Number, allow Special Character:
       "^[a-zA-Z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{6,30}$"
    
     * Minimum 8 and Maximum 30 characters Uppercase Alphabet Number:
       "^[a-zA-Z0-9]{8,30}$"
     
     * Minimum 8 characters at least 1 Alphabet and 1 Number:
        "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
     
     * Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:
        "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
     
     * Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number:
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
     
     * Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
     
     * Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,10}"
     */
    
    var isValidCMND: Bool {
        if self.getBytesBy(encoding: SystemUtils.shiftJISEncoding) != self.count { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.{8,}$")
        return passwordTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        if self.getBytesBy(encoding: SystemUtils.shiftJISEncoding) != self.count { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{6,30}$")
        return passwordTest.evaluate(with: self)
    }
    
    var isFullSizeCharacter: Bool {
        return getBytesBy(encoding: SystemUtils.shiftJISEncoding) == 2
    }

    // MARK: - Static functions
    static func randomStringWith(type: RandomStringType, length: Int) -> String {
        let letters: NSString = type.text as NSString
        let len = UInt32(letters.length)
        var randomString = ""
        (0..<length).forEach { _ in
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    static func add(separator text: String = ",", to number: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = text
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    // MARK: - Local functions
    func first(_ length: Int) -> String {
        return String(self.prefix(length))
    }
    
    func last(_ length: Int) -> String {
        return String(self.suffix(length))
    }
    
    func startIndex(of subString: String) -> Int? {
        if let range = self.range(of: subString) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func endIndex(of subString: String) -> Int? {
        if let range = self.range(of: subString, options: .backwards) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func getBytesBy(encoding: String.Encoding) -> Int? {
        return data(using: encoding)?.count
    }
    
    func replace(string: String, with newString: String) -> String {
        return self.replacingOccurrences(of: string, with: newString)
    }
    
    func nsrangeOf(subString: String) -> NSRange? {
        if let range = self.range(of: subString) {
            return NSRange(range, in: self)
        }
        return nil
    }
    
    func numberBy(removing separator: String) -> Int {
        let seperatedArr = components(separatedBy: separator)
        var finalNumber = 0
        for (i, numStr) in seperatedArr.reversed().enumerated() {
            if let dNum = Int(numStr) {
                finalNumber += dNum * Int(pow(10, Double(i)))
            }
        }
        return finalNumber
    }
    
    func dateBy(format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }

    func convertDateFormater() -> String {
        let dates = self.split(separator: "T")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd "
        if dates.count > 0 {
            let date = dateFormatter.date(from: "\(dates[0])")
            dateFormatter.dateFormat = "dd/MM/YYYY"
            return  dateFormatter.string(from: date ?? Date())
        } else {
            dateFormatter.dateFormat = "dd/MM/YYYY"
            return dateFormatter.string(from: Date())
        }
        
    }
    
    func textBoundsWith(width: CGFloat, font: UIFont) -> CGRect {
        let st = self as NSString
        return st.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                               options: .usesLineFragmentOrigin,
                               attributes: [.font: font],
                               context: nil)
    }
    
    func textBoundsWith(height: CGFloat, font: UIFont) -> CGRect {
        let st = self as NSString
        return st.boundingRect(with: CGSize(width: CGFloat(CGFloat.greatestFiniteMagnitude), height: height),
                               options: .usesLineFragmentOrigin,
                               attributes: [.font: font],
                               context: nil)
    }
    
    func dateByLocale(_ identifier: String, format: String ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.dateFormat = format
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.calendar = Date.currentCalendar
        dateFormatter.timeZone = Date.currentTimeZone
        return dateFormatter.date(from: self)
    }
    
    func heightWith(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func widthWith(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    var trimToShowChatbot: String {
        return self.replace(string: "\n", with: "\\n")
            .replace(string: "\"", with: "\\\"")
            .replace(string: "\'", with: "\\\'")
    }
    
    func phoneTrimming() -> String {
        return self.components(separatedBy:CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    var trimToSpeech: String {
        return self.replace(string: "\\n", with: ". ")
            .replace(string: "\\", with: "")
    }
    
    var decimal: NSDecimalNumber {
        return NSDecimalNumber(string: self)
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension String {
    func attributedString(color: UIColor, font: UIFont, alignment: NSTextAlignment = .left, firstLinePadding: CGFloat = 0, lineSpacing: CGFloat? = 8) -> NSAttributedString {
        
        var attributes : [NSAttributedString.Key : Any] = [
            .foregroundColor: color,
            .font: font
        ]
        
        if let lineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            // add alignment
            paragraphStyle.alignment = alignment
            // add line spacing for paragraph
            paragraphStyle.lineSpacing = lineSpacing
            // add first line space for paragraph
            paragraphStyle.firstLineHeadIndent = firstLinePadding
            
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func width(withHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func changeTimeShortFormat() -> String {
        guard let date = self.dateBy(format: "HH:mm:ss", calendar: Date.currentCalendar, timeZone: Date.currentTimeZone)
            else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func getViews() -> String{
        let value = Int(self) ?? 0
        if value >= 0 && value < 1000 {
           return self
        } else if value >= 1000 && value < 1000000 {
            let valueConvert = Double(value) / 1000
            return String.init(format: "%0.1fK", valueConvert).replace(string: ".", with: ",")
        } else {
            let valueConvert = Double(value) / 1000000
            return String.init(format: "%0.1fM", valueConvert).replace(string: ".", with: ",")
        }
    }
    
    func changeDateShortFormat() -> String {
        let date = self.dateBy(format: "YYYY-MM-dd", calendar: Calendar.current, timeZone: TimeZone.current)
        let string = "\(date?.day ?? 0) \(date?.monthForVietnamese ?? "")"
        return string
    }
    
    func numberOfLinesInLabel( size: CGSize, font: UIFont) -> Int {
        
        let textStorage = NSTextStorage(string: self, attributes: [NSAttributedString.Key.font: font])
        
        let textContainer = NSTextContainer(size: size)
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 0
        textContainer.lineFragmentPadding = 0
        
        let layoutManager = NSLayoutManager()
        layoutManager.textStorage = textStorage
        layoutManager.addTextContainer(textContainer)
        
        var numberOfLines = 0
        var indexValue = 0
        var lineRange : NSRange = NSMakeRange(0, 0)
        for index in indexValue..<layoutManager.numberOfGlyphs{
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            indexValue = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        
        return numberOfLines
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


extension String {
    mutating func paragraphBeautyFormat() -> String {
        let tamp = self.removeMultipleNewlinesFromMiddle()
        return tamp.replace(string: "\n", with: "\n\n").trimWhiteSpacesAndNewLines
    }
    
    func removeMultipleNewlinesFromMiddle() -> String {
        let returnString = self.replacingOccurrences(of: "\n+", with: "\n", options: .regularExpression, range: nil)
        return (returnString)
    }

}


extension String {
    func isValidDate(format: String? = "yyyy-MM-dd") -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = format
        if let _ = dateFormatterGet.date(from: self) {
            return true
        } else {
            return false
        }
    }
}


// String to DateString
extension String {
    func toDate(format: String? = "yyyy-MM-dd'T'HH:mm:ss'Z'", timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from: self)
        
        return date
    }
    
    func toDateString(format: String? = "yyyy-MM-dd'T'HH:mm:ss'Z'") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        
        if let date = date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "dd-MM-yyyy"
            let result = formatter.string(from: date)
            
            return result
        }
        
        return nil
    }
    
    func convertDateStringToString(inFormat: String = "HH:mm dd/MM/yyyy", timeZone: TimeZone = Date.currentTimeZone, outFormat: String = "dd/MM/yyyy \t\t hh:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from: self)
        if let date = date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = outFormat
            let result = formatter.string(from: date)
            return result
        }
        return ""
    }
}


// Convert special text to normal. Ex: Aăbcđ -> aabcd (for searching)
extension String {
    func convertSpecialTextToNormalForSearching(isRemoveSpacing: Bool = true) -> String {
        var result = self.folding(options: .diacriticInsensitive, locale: nil) //Aăb cđe -> aab cđe
        result = result.lowercased()
        result = result.replace(string: "đ", with: "d") //aab cđe -> aab cde
        
        if isRemoveSpacing {
            result = result.replace(string: " ", with: "") //aab cde -> aabcde
        }
        
        return result
    }
}

extension String {
    func checkCharacters() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    var pathExtension: String {
        return fileURL.pathExtension
    }
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
    var deletingPathExtension: String {
        return fileURL.deletingPathExtension().absoluteString
    }
    var deletingLastPath: String {
        return fileURL.deletingLastPathComponent().absoluteString
    }
}

// Make a part of String with attribute

extension String {
    func attributedText(boldStrings: [String], font: UIFont, boldFontName: String = "Lato-Bold") -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self,
                                                     attributes: [NSAttributedString.Key.font: font])
        if let boldFont = UIFont(name: boldFontName, size: font.pointSize) {
            let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: boldFont]
            for boldString in boldStrings {
                let range = (self as NSString).range(of: boldString)
                attributedString.addAttributes(boldFontAttribute, range: range)
            }
        }
        return attributedString
    }
}

// Encrypt/ Decrypt

extension String {
    func aesEncrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = self.data(using: String.Encoding.utf8),
            let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {


            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            var numBytesEncrypted :size_t = 0

            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
            }
            else {
                return nil
            }
        }
        return nil
    }

    func aesDecrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {

            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)

            var numBytesEncrypted :size_t = 0

            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                return unencryptedMessage
            }
            else {
                return nil
            }
        }
        return nil
    }
}


extension String {
    
    /// Inner comparison utility to handle same versions with different length. (Ex: "1.0.0" & "1.0")
    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        
        let versionDelimiter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimiter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
        let spareCount = versionComponents.count - targetComponents.count
        
        if spareCount == 0 {
            result = compare(targetVersion, options: .numeric)
        } else {
            let spareZeros = repeatElement("0", count: abs(spareCount))
            if spareCount > 0 {
                targetComponents.append(contentsOf: spareZeros)
            } else {
                versionComponents.append(contentsOf: spareZeros)
            }
            result = versionComponents.joined(separator: versionDelimiter)
                .compare(targetComponents.joined(separator: versionDelimiter), options: .numeric)
        }
        return result
    }
    
    public func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }
    public func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }
    public func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }
    public func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }
    public func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }
}

//MARK: - Get Youtube ID from URL
extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"

        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)

        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }

        return (self as NSString).substring(with: result.range)
    }
}

extension Optional where Wrapped == String {
    
    var isEmpty: Bool {
        if let str = self {
            return str.isEmpty
        }
        return true
    }
    
    var isNumber: Bool {
        if let str = self {
            return str.isNumber
        }
        return false
    }
    
    var isNumeric: Bool {
        if let str = self {
            return str.isNumeric
        }
        return false
    }
    
    var isEmail: Bool {
        if let str = self {
            return str.isEmail
        }
        return false
    }
    
    var isPhoneNumber: Bool {
        if let str = self {
            return str.isValidPhone
        }
        return false
    }
    
    var isLetter: Bool {
        if let str = self {
            return str.isLetter
        }
        return false
    }
    
    var isAlphanumeric: Bool {
        if let str = self {
            return str.isAlphanumeric
        }
        return false
    }
    
    var decimal: NSDecimalNumber {
        return NSDecimalNumber(string: self)
    }
}
