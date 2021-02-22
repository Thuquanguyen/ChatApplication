//
//  UIAlertController+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import Foundation
import UIKit

typealias SystemAlertButtonData = (title: String, style: UIAlertAction.Style, handler: (() -> Void)?)

// Extension for system alert view
extension UIAlertController {
    static func showQuickSystemAlert(target: UIViewController? = UIViewController.top(),
                                     title: String? = nil,
                                     message: String? = nil,
                                     cancelButtonTitle: String = "OK",
                                     handler: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
            handler?()
        }))
        target?.present(alertVC, animated: true)
    }
    
    static func showSystemAlert(target: UIViewController? = UIViewController.top(),
                                title: String? = nil,
                                message: String? = nil,
                                buttons: [String],
                                handler: ((_ index: Int, _ title: String) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.enumerated().forEach { button in
            let action = UIAlertAction(title: button.element, style: .default, handler: { _ in
                APIAlertPresenter.instance.removeCurrentAlert()
                handler?(button.offset, button.element)
            })
            alert.addAction(action)
        }
        DispatchQueue.main.async {
            target?.present(alert, animated: true)
        }
    }
    
    static func showSystemAlert(target: UIViewController? = UIViewController.top(),
                                title: String? = nil,
                                message: String? = nil,
                                buttons: [SystemAlertButtonData]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.forEach { button in
            let action = UIAlertAction(title: button.title, style: button.style, handler: { _ in
                APIAlertPresenter.instance.removeCurrentAlert()
                button.handler?()
            })
            alert.addAction(action)
        }
        target?.present(alert, animated: true)
    }
    
    static func showSystemActionSheet(target: UIViewController? = UIViewController.top(),
                                      title: String? = nil,
                                      message: String? = nil,
                                      optionButtons: [SystemAlertButtonData],
                                      cancelButton: SystemAlertButtonData) {
        let viewBG = UIView(frame: UIScreen.main.bounds)
        let backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        optionButtons.forEach { (button) in
            alert.addAction(UIAlertAction(title: button.title, style: button.style, handler: { (_) in
                viewBG.removeFromSuperview()
                APIAlertPresenter.instance.removeCurrentAlert()
                button.handler?()
            }))
        }
        let cancelAction = UIAlertAction(title: cancelButton.title, style: UIAlertAction.Style.cancel, handler: { (_) in
            viewBG.removeFromSuperview()
            APIAlertPresenter.instance.removeCurrentAlert()
            cancelButton.handler?()
        })
        alert.addAction(cancelAction)
        viewBG.backgroundColor = backgroundColor
        target?.view.addSubview(viewBG)
        target?.present(alert, animated: true)
    }
    
    static func showOfflineErrorAlert(target: UIViewController? = UIViewController.top(),
                                      completion: @escaping ((_ index: Int, _ isRetry: Bool) -> Void)) {
        let alert = APIUIEvent.offlineErrorDialog(autoPopPreviousVC: false, completion: { index, isRetry in
            APIAlertPresenter.instance.removeCurrentAlert()
            completion(index, isRetry)
        })
        guard !APIAlertPresenter.instance.isPresentingAlert else {
            APIAlertPresenter.instance.add(alert: alert)
            return
        }
        APIAlertPresenter.instance.isPresentingAlert = true
        target?.present(alert, animated: true)
    }
    
    static func showAlertToSettings(title: String) {
        UIAlertController.showSystemAlert(message: title, buttons: ["Huỷ bỏ", "OK"]) { (index, _) in
            if index == 1 {
            } else {
                return
            }
        }
    }
}
