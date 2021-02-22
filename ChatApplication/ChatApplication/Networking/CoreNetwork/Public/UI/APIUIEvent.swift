//
//  APIUIEvent.swift
//  TetViet
//
//  Created by vinhdd on 12/14/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit

// MARK: - Handle UI events
class APIUIEvent {
    static func showIndicator() {
        // Write your code to show your own indicator
        // Example:
        IndicatorViewer.show()
    }
    
    static func hideIndicator() {
        // Write your code to hide your own indicator
        // Example:
        Utils.sleep(0.3, completion: {
            IndicatorViewer.hide()
        })
    }
    
    static func apiErrorDialog(error: APIError, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: nil, message: error.message, preferredStyle: .alert)
        alertVC.view.tag = APIAlertType.normal.value
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            APIAlertPresenter.instance.removeCurrentAlert()
            completion()
        }))
        return alertVC
    }
    
    static func requestErrorDialog(error: APIError, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: nil, message: error.message, preferredStyle: .alert)
        alertVC.view.tag = APIAlertType.normal.value
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        }))
        return alertVC
    }
    
    static func offlineErrorDialog(autoPopPreviousVC: Bool = true,completion: @escaping ((_ index: Int, _ tapRetry: Bool) -> Void)) -> UIAlertController {
        let title = "alert_no_connection".localized
        let message = "alert_no_connection_try".localized
        let buttons = ["place_ratting_vote_try_again".localized, "alert.default_login_close".localized]
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.view.tag = APIAlertType.offline.value
        buttons.enumerated().forEach { button in
            let action = UIAlertAction(title: button.element, style: .default, handler: { _ in
                APIAlertPresenter.instance.removeCurrentAlert()
                if button.offset == 0 {
                    completion(button.offset, true)
                } else {
                    if autoPopPreviousVC {VCService.pop()}
                    completion(button.offset, false)
                }
                
            })
            alertVC.addAction(action)
        }
        return alertVC
    }
}
