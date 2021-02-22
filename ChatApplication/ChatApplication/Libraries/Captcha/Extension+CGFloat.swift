//
//  File.swift
//  
//
//  Created by Kathiresan on 15/12/19.
//

import Foundation
import UIKit

extension CGFloat {
    
    /// Random cg float
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
