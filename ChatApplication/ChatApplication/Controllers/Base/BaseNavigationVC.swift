//
//  BaseNavigationVC.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

class BaseNavigationVC: UINavigationController {
    
    // MARK: - Closures
    typealias NavigationCompletion = (() -> Void)?
    
    // MARK: - Properties
    var listCompletion: [String: NavigationCompletion] = [:]
    
    // MARK: - ViewController's life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        self.delegate = self
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: NavigationCompletion) {
        listCompletion[String(describing: type(of: viewController))] = completion
        self.pushViewController(viewController, animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
}

extension BaseNavigationVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
         listCompletion.removeValue(forKey: String(describing: type(of: viewController)))??()
    }
}


