//
//  File.swift
//  
//
//  Created by Kathiresan on 15/12/19.
//

import Foundation
import UIKit

extension UIColor {
    
    /// Random color
    static func random() -> UIColor {
        let colors: [UIColor] = [.green, .blue, .black, .cyan, .darkText]
        return colors.randomElement() ?? UIColor.black
    }
}
