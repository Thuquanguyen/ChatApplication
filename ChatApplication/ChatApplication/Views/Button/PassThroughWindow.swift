//
//  PassThroughWindow.swift
//  TetViet
//
//  Created by vinhdd on 1/14/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
