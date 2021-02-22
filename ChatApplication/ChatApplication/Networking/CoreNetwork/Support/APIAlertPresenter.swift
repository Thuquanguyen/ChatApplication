//
//  APIAlertManager.swift
//  TetViet
//
//  Created by vinhdd on 12/23/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit

enum APIAlertType: Int {
    case offline = 0
    case normal = 1
    
    var value: Int { return rawValue }
}

class APIAlertPresenter {

    // MARK: - Singleton
    static let instance = APIAlertPresenter()
    
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
        if alert.view.tag == APIAlertType.offline.value && pendingAlerts.contains { $0.view.tag == APIAlertType.offline.value } {
            return
        }
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

