
//
//  CaptchaGenerator.swift
//  CaptchaSWift
//
//  Created by Kathiresan on 15/12/19.
//  Copyright © 2019 Kathiresan. All rights reserved.
//

import Foundation
import UIKit

/// Captcha generator
public struct CaptchaGenerator {
    
    public init() {}
    
    ///Alpha numeric
    static private let alphaNumeric = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789"
    
    /// Current captcha text
    fileprivate var currentCaptchaText: String = ""
    
    /// Random text
    /// - Parameter length: number fo length
    static private func randomString(length: Int) -> String {
        return String((0..<length).map{ _ in alphaNumeric.randomElement()! })
    }
    
    /// attributed keys
    private var attributedKeys: [NSAttributedString.Key: Any] {
        [NSAttributedString.Key.font: UIFont.random(), NSAttributedString.Key.foregroundColor: UIColor.random()]
    }

    /// Generate Captcha
    mutating public func generate() -> NSAttributedString {
        let captcha = CaptchaGenerator.randomString(length: 5)
        
        self.currentCaptchaText = captcha
        
        let attributed = NSMutableAttributedString(string: captcha)
        
        attributed.addAttributes(attributedKeys, range: NSRange(location: 0, length: 1))
        attributed.addAttributes(attributedKeys, range: NSRange.init(location: 1, length: 1))
        attributed.addAttributes(attributedKeys, range: NSRange.init(location: 2, length: 1))
        attributed.addAttributes(attributedKeys, range: NSRange.init(location: 3, length: 1))
        
        return attributed
    }
    
    /// Is Matched
    /// - Parameters:
    ///   - text: text
    ///   - inCaseSensitive: is Case sensitive
    public func isMatched(text: String, inCaseSensitive: Bool = false ) -> Bool {
        return inCaseSensitive ? currentCaptchaText == text : currentCaptchaText.lowercased() == text.lowercased()
    }
}



