//
//  UIViewController+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import AVKit
import UIKit

protocol XibViewController {
    static var name: String { get }
    static func create() -> Self
}

extension XibViewController where Self: UIViewController {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func create() -> Self {
        return self.init(nibName: Self.name, bundle: nil)
    }
    
    static func present(from: UIViewController? = top(),
                        animated: Bool = true,
                        prepare: ((_ vc: Self) -> Void)? = nil,
                        completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        prepare?(targetVC)
        parentVC.present(targetVC, animated: animated, completion: completion)
    }
    
    static func push(from: UIViewController? = top(),
                     animated: Bool = true,
                     prepare: ((_ vc: Self) -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        prepare?(targetVC)
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        parentVC.navigationController?.pushViewController(targetVC, animated: animated)
        CATransaction.commit()
    }
}

extension UIViewController: XibViewController { }

extension UIViewController {
    
    var name: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    var isModal: Bool {
        if let navController = self.navigationController, navController.viewControllers.first != self {
            return false
        }
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    var isVisible: Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    func push(_ vc: UIViewController, animation: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animation)
    }
    
    class func top(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return top(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return top(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return top(controller: presented)
        }
        return controller
    }
    
    func dismissToRoot(controller: UIViewController? = UIViewController.top(),
                       animated: Bool = true,
                       completion: ((_ rootVC: UIViewController?) -> Void)? = nil) {
        guard let getController = controller else {
            completion?(nil)
            return
        }
        if let prevVC = getController.presentingViewController {
            if prevVC.isModal && prevVC.presentingViewController != nil {
                dismissToRoot(controller: prevVC, animated: animated, completion: completion)
            } else {
                getController.dismiss(animated: animated, completion: {
                    completion?(prevVC)
                })
            }
        } else {
            completion?(getController)
        }
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func findViewController<T: UIViewController>(type: T.Type) -> T? {
        var result: T? = nil
        if let vcs = navigationController?.viewControllers {
            result = vcs.first(where: {$0 as? T != nil}) as? T
        }
        if result == nil {
        }
        return result
    }
    
    func removeVCFromNavigation<T: UIViewController>(type: T.Type) {
        if let navi = navigationController,
            let vc = findViewController(type: type),
            let at = navi.viewControllers.index(of: vc) {
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            navi.viewControllers.remove(at: at)
        }
    }
    
    func parrentFromNavigation() -> UIViewController? {
        if let vcs = navigationController?.viewControllers,
            let at = vcs.index(of: self) {
            return vcs[safe: at - 1]
        }
        return nil
    }
    
    func removeVCFromNavigation() {
        if let navi = navigationController,
            let at = navi.viewControllers.index(of: self) {
            navi.viewControllers.remove(at: at)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}

extension UIViewController {
    
    @available(iOS 11.0, *)
    public var hideKeyBoardWhenTouchOutSide : Bool {
        get {
            return view.gestureRecognizers?.filter({ $0.name == "tapHideKeyBoard" }) == nil ? false : true
        }
        set {
            guard let gestureRecognizers = view.gestureRecognizers,
                let tapHideKeyBoard = gestureRecognizers.filter({ $0.name == "tapHideKeyBoard" }).first else {
                    if newValue {
                        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
                        tap.name = "tapHideKeyBoard"
                        tap.cancelsTouchesInView = false
                        view.addGestureRecognizer(tap)
                    }
                    return
            }
            if !newValue {
                view.removeGestureRecognizer(tapHideKeyBoard)
            }
        }
    }
    
    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
    #if os(iOS)
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    #endif
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    @discardableResult
    func showPopup(animation duration: TimeInterval = 0.5, title: String? = nil, titleAttribute: NSAttributedString? = nil, image: UIImage? = nil, tintColor: UIColor? = nil,
                   imageSize: CGSize = CGSize(width: 40, height: 40), content: String? = nil,
                   contentAttribute: NSAttributedString? = nil, accept: String? = nil, removeAlert: Bool = false, acceptAction: (() -> ())? = nil) -> AlertView {
        let alertView = AlertView.showAlert(title: title, titleAttribute: titleAttribute, image: image, tintcolor: tintColor,
                                            imageSize: imageSize, content: content, contentAttribute: contentAttribute,
                                            accept: accept, removeAlert: removeAlert, acceptAction: acceptAction)
        AppDelegate.shared.window?.addSubview(alertView)
        alertView.fitParent()
        alertView.show(duration: duration)
        return alertView
    }
    
    func promptToAppSettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Huỷ", comment: "Alert OK button"), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cài đặt", comment: "Alert button to open Settings"), style: .default, handler: { action in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(appSettings)
                }
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    class func topViewController(controller: UIViewController? = AppDelegate.shared.window?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        return controller
    }
    
    static func topControllerIs<T: UIViewController>(_ type: T.Type) -> Bool {
        guard let topVC = topViewController() else { return false }
        return topVC.isKind(of: type)
    }
    
    func destroy(animated: Bool = false)  {
        if let nav = self.navigationController, nav.children.count > 1 {
            nav.popViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }
}

extension UIViewController {
    
    func presentPreviewFile(url: URL) {
        let documentInteraction = UIDocumentInteractionController(url: url)
        documentInteraction.delegate = self
        documentInteraction.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteraction.name = url.localizedName ?? url.lastPathComponent
        documentInteraction.presentPreview(animated: true)
    }
    
}

extension UIViewController: UIDocumentInteractionControllerDelegate {
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

protocol InterfaceIdentifiable: class {
    static var interfaceId: String { get }
    static var nib: UINib { get }
}

extension InterfaceIdentifiable {
    static var interfaceId: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: interfaceId, bundle: nil)
    }
}

extension InterfaceIdentifiable where Self: UIViewController {
    static func initFromNib() -> Self {
        return Self(nibName: interfaceId, bundle: nil)
    }
}

extension UIView: InterfaceIdentifiable { }
extension UIViewController: InterfaceIdentifiable { }


extension UIViewController {
    func addViewController(vc: UIViewController, viewBase: UIView){
        DispatchQueue.main.async {
            vc.willMove(toParent: self)
            self.addChild(vc)
            vc.view.frame = viewBase.bounds
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewBase.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
        
    func showDialog(height: CGFloat = UIScreen.main.bounds.height) {
          guard let parentVC = UIViewController.top() else { return }
          let nav = UINavigationController(rootViewController: self)
          nav.modalPresentationStyle = .custom
          nav.navigationBar.isHidden = true
          nav.interactivePopGestureRecognizer?.isEnabled = false
          let delegate = ModalTransitioningDelegate(height)
          nav.transitioningDelegate = delegate
          parentVC.present(nav, animated: true, completion: nil)
      }
    
    func remove() {
        if self.isViewLoaded {
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}


class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let height: CGFloat
    init( _ height: CGFloat) {
        self.height = height
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentVC = BaseFilterVC(presentedViewController: presented, presenting: presenting)
        presentVC.heightPresentView = height
        return presentVC
    }
}
