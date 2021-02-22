//
//  UIScrollView+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func scrollToVeryBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.height + contentInset.bottom)
        if bottomOffset.y > contentOffset.y {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
