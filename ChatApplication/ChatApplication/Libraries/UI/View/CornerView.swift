//
//  CornerView.swift
//  TetViet
//
//  Created by QuangLH on 12/27/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit

class CornerView: UIView {
    
    // MARK: - IBInspectables
    @IBInspectable var cornerTopLeft: Bool = true
    @IBInspectable var cornerTopRight: Bool = true
    @IBInspectable var cornerBottomLeft: Bool = true
    @IBInspectable var cornerBottomRight: Bool = true
    @IBInspectable var cornerRadius: CGFloat = 0
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var cornerList = UIRectCorner()
        if cornerTopLeft { cornerList.insert(.topLeft) }
        if cornerTopRight { cornerList.insert(.topRight) }
        if cornerBottomLeft { cornerList.insert(.bottomLeft) }
        if cornerBottomRight { cornerList.insert(.bottomRight) }
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: cornerList, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
