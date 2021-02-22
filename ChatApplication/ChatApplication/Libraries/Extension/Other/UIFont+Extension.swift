//
//  UIFont+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func light(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func italic(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Italic", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func thin(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Thin", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
