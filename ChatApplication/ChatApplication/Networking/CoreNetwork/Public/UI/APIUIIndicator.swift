//
//  APIUIEvent.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit

// MARK: - Handle UI events
class APIUIIndicator {
    
    public static var loadingView: LoadingView?
    
    static func showIndicator() {
        // Write your code to show your own indicator
        // Example:
        if APIUIIndicator.loadingView == nil {
            APIUIIndicator.loadingView = LoadingView.loading()
        }
    }
    
    static func hideIndicator() {
        // Write your code to hide your own indicator
        // Example:
        APIUIIndicator.loadingView?.hidden(removeFromParent: true)
        APIUIIndicator.loadingView = nil
    }
}
