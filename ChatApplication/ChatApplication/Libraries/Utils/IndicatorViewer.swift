//
//  IndicatorViewer.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
class IndicatorViewer {
    static func show() {
       APIUIIndicator.showIndicator()
    }

    static func hide() {
       APIUIIndicator.hideIndicator()
    }
}
