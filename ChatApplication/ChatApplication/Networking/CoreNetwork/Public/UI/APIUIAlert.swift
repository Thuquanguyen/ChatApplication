//
//  APIUIAlert.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/18/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

// MARK: - Init list of dialogs
class APIUIAlert {
    static func apiErrorDialog(error: APIError, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: nil, message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        }))
        return alertVC
    }
    
    static func requestErrorDialog(error: APIError, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: nil, message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        }))
        return alertVC
    }
    
    static func offlineErrorDialog(completion: @escaping ((_ index: Int, _ tapRetry: Bool) -> Void)) -> UIAlertController {
        let title = "alert_no_connection".localized
        let message = "alert_no_connection_try".localized
        let buttons = ["place_ratting_vote_try_again".localized, "alert.default_login_close".localized]
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.enumerated().forEach { button in
            let action = UIAlertAction(title: button.element, style: .default, handler: { _ in
                completion(button.offset, button.offset == 0)
            })
            alertVC.addAction(action)
        }
        return alertVC
    }
}

// MARK: - Presenting functions
extension APIUIAlert {
    static func showApiErrorDialogWith(error: APIError, completion: @escaping (() -> Void)) {
        _ = AlertView.showAlert(content: error.message, accept: "OK")
    }
    
    static func showRequestErrorDialogWith(error: APIError, completion: @escaping (() -> Void)) {
        _ = AlertView.showAlert(content: error.message, accept: "OK")
    }
    
    static func showOfflineErrorDialog(completion: @escaping ((_ index: Int, _ tapRetry: Bool) -> Void)) {
        _ = AlertView.showAlert(title: "alert_no_connection".localized, content: "alert_no_connection_try".localized, accept: "alert.default_login_close".localized)
    }
}
