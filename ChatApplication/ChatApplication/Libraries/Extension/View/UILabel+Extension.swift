//
//  UILabel+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

extension UILabel {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.text = self.text?.localized
    }
    
    // MARK: - Variables
    var lineNumber: Int {
        var lineCount = 0
        let textSize = CGSize(width: frame.size.width, height: .greatestFiniteMagnitude)
        let rHeight = lroundf(Float(sizeThatFits(textSize).height))
        let charSize = lroundf(Float(font.lineHeight))
        lineCount = rHeight / charSize
        return lineCount
    }
    
    // MARK: - Functions
    func sizeFit(width: CGFloat) -> CGSize {
        self.numberOfLines = Int.max
        let fixedWidth = width
        let newSize = sizeThatFits(CGSize(width: fixedWidth,
                                          height: .greatestFiniteMagnitude))
        return CGSize(width: fixedWidth, height: newSize.height)
    }
    
    func sizeFit(height: CGFloat) -> CGSize {
        self.numberOfLines = Int.max
        let fixedHeight = height
        let newSize = sizeThatFits(CGSize(width: .greatestFiniteMagnitude,
                                          height: fixedHeight))
        return CGSize(width: newSize.width, height: fixedHeight)
    }
    
    func underline() {
        if let text = self.text {
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: textRange)
            self.attributedText = attributedText
        }
    }
    
    func underlineFor(subString: String) {
        guard let text = self.text, let subRange = text.nsrangeOf(subString: subString) else { return }
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: subRange)
        self.attributedText = attributedText
    }
    
    func set(lineSpacing value: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = value
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = self.textAlignment
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}


extension UILabel {
    
    // Pass value for any one of both parameters and see result
    func setLineSpacing(lineSpacing: CGFloat = 3.5, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
// MARK: Set HTML
extension UILabel {
    
    func set(html: String) {
        if let htmlData = html.data(using: .unicode) {
            do {
                self.attributedText = try NSAttributedString(data: htmlData,
                                                             options: [.documentType: NSAttributedString.DocumentType.html],
                                                             documentAttributes: nil)
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }
}


extension UILabel {
    func addShadowForLabel(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
    func setShadowHighlightAroundLabel() {
        self.addShadowForLabel(color: .gray, opacity: 0.4, offSet: CGSize(width: 1.0, height: 1.0), radius: 2.0)
    }
}

extension UILabel {
    private var requiredText: String {
        return "*"
    }
    
    func setRequiredText(font: UIFont? = nil, textRequired: String? = nil) {
        let font = font ?? self.font
        let required = textRequired ?? self.requiredText
        guard let text = text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let requiredText = NSMutableAttributedString(string: required, attributes: [.foregroundColor: UIColor("FF738E"), .font: font as Any])
        attributedString.append(requiredText)
        attributedString.addAttributes([.font: font as Any, .foregroundColor: textColor], range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
    
    func removeRequiredText(textRequired: String? = nil) {
        let required = textRequired ?? self.requiredText
        guard text?.hasSuffix(required) == true, let result = text?.dropLast(required.count) else { return }
        text = String(result)
    }
    
    func setImage(text: String? = nil, _ image: UIImage, sizeImage: CGSize? = nil) {
        let size = sizeImage ?? CGSize(width: image.size.width, height: image.size.height)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds.size = size
        imageAttachment.bounds.origin = CGPoint(x: 0, y: -5)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        completeText.append(NSAttributedString(string: text ?? self.text ?? ""))
        attributedText = completeText
    }
}
