//
//  UIStackView+Extension.swift
//  XKLD
//
//  Created by SonDT-D1 on 5/11/20.
//  Copyright © 2020 RikkeiSoft. All rights reserved.
//

import Foundation
import UIKit


extension UIStackView {
    func removeAllArrangedSubviews() {
            arrangedSubviews.forEach {
                self.removeArrangedSubview($0)
                NSLayoutConstraint.deactivate($0.constraints)
                $0.removeFromSuperview()
            }
        }
}
