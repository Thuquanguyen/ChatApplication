//
//  GlobalFunction.swift
//  AIC Utilities People
//
//  Created by toannt on 5/13/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func dispatchMainAsync(excute: @escaping ()-> Void) {
    DispatchQueue.main.async(execute: excute)
}
