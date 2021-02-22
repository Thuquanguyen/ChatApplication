//
//  BaseTapGestureRecognizer.swift
//  YTeThongMinh
//
//  Created by DatTV on 6/1/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit


class BaseTapGesture: UITapGestureRecognizer {
    
    var data: Any?
    
    init(target: Any?, action: Selector?, data: Any?) {
        super.init(target: target, action: action)
        self.data = data
    }
}
