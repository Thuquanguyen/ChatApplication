//
//  BaseLabel.swift
//  YTeThongMinh
//
//  Created by DatTV on 5/28/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    @IBInspectable var isRequired: Bool = false  {
        didSet {
            if isRequired {
                setRequiredText(textRequired: textRequired)
            }
        }
    }
    @IBInspectable var textRequired: String = "" {
        didSet {
            if isRequired {
                setRequiredText(textRequired: textRequired)
            }
        }
    }

    override var text: String? {
        didSet {
            if isRequired {
                setRequiredText()
            }
        }
    }
    

    override func drawText(in rect: CGRect) {
       let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
       get {
          var contentSize = super.intrinsicContentSize
          contentSize.height += topInset + bottomInset
          contentSize.width += leftInset + rightInset
          return contentSize
       }
    }
}
