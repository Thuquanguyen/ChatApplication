//
//  File.swift
//  AIC Utilities People
//
//  Created by ThuanHC on 5/30/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 2
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}
