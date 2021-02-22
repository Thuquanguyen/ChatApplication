//
//  FieldsValidationAlertPresenter.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 7/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class FieldsValidationAlertPresenter {
    
    // MARK: - Singleton
    static let instance = FieldsValidationAlertPresenter()
    
    // MARK: - Variables
    private var pendingAlerts: [UIAlertController] = []
    var isPresentingAlert: Bool = false
    
    // MARK: - Init & deinit
    init() {
        
    }
    
    // MARK: - Setup
    
    // MARK: - Builder
    
    // MARK: - Action
    func add(alert: UIAlertController) {
        // If offline alert has already exists, don't add more
        pendingAlerts.append(alert)
    }
    
    func removeCurrentAlert() {
        isPresentingAlert = false
        guard !pendingAlerts.isEmpty else { return }
        pendingAlerts.removeFirst()
        if !pendingAlerts.isEmpty, let newAlert = pendingAlerts.first {
            UIViewController.topViewController()?.present(newAlert, animated: true)
        }
    }
    
    func reset() {
        pendingAlerts.removeAll()
        isPresentingAlert = false
    }
}


class FieldsValidationAlertController {
    static func showErrorDialog(error: String?, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alertVC.view.tag = APIAlertType.normal.value
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        }))
        return alertVC
    }
}



