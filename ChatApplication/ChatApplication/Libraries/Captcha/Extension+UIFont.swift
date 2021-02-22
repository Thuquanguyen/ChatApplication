//
//  File.swift
//  
//
//  Created by Kathiresan on 15/12/19.
//

import Foundation
import UIKit

extension UIFont {
    
    /// Random font
    static func random() -> UIFont {
        let fonts = [UIFont.systemFont(ofSize: 23),
                     UIFont.init(name: "Bradley Hand", size: 25)!,
                     UIFont.init(name: "Chalkboard SE", size: 22)!,
                     UIFont.init(name: "Zapfino", size: 25)!,
                     UIFont.init(name: "PartyLETPlain", size: 25)!,
                     UIFont.init(name: "Times New Roman", size: 24)!]
        
        return fonts.randomElement() ?? systemFont(ofSize: 24)
    }
}
