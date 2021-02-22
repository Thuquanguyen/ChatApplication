//
//  BaseFilterVC.swift
//  AIC Utilities People
//
//  Created by TiemLV on 5/16/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

@objc
protocol FilterViewDelegate {
    
}

class BaseFilterVC: UIPresentationController {
    
    // MARK: - Properties
    lazy var backdropView: UIView = {
        let bdView = UIView()
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    var dismissOnTapOutside: Bool = true
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    var heightPresentView: CGFloat = 0 // set height of filter view controller
    
    var updateHeightFilter: CGFloat = 0 {
        didSet {
            if self.containerView == nil { return }
            heightPresentView = updateHeightFilter
            containerViewDidLayoutSubviews()
        }
    }
    
    // MARK: - Closures
    var disMissView: (() -> Void)?
    
    @objc func dismiss(){
        if dismissOnTapOutside {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        self.backdropView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backdropView.isUserInteractionEnabled = true
        self.backdropView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        /*
        let height = min(heightPresentView, self.containerView!.frame.height/2)
        let pointY: CGFloat = self.containerView!.frame.height - height
        
        return CGRect(origin: CGPoint(x: 0, y: pointY), size: CGSize(width: self.containerView!.frame.width, height: height))
         */
        let pointY: CGFloat = self.containerView!.frame.height - heightPresentView
        
        return CGRect(origin: CGPoint(x: 0, y: pointY), size: CGSize(width: self.containerView!.frame.width, height: heightPresentView))
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.backdropView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.backdropView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionWillBegin() {
        self.backdropView.alpha = 0
        self.containerView?.addSubview(backdropView)
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.backdropView.alpha = 1
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
    }
    
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        backdropView.frame = containerView!.bounds
    }

    func updateHeight(height: CGFloat) {
        guard let presentedView = presentedView,
              let containerView = containerView else { return }

        heightPresentView = height
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [],
            animations: {
                var frame = presentedView.frame
                frame.origin = CGPoint(x: frame.minX, y: containerView.frame.maxY - height)
                frame.size = CGSize(width: frame.width,
                                    height: height < frame.height ? frame.height : height)
                presentedView.frame = frame
            }, completion: { completed in
            })
    }
    
    func updateHeightPresent(height: CGFloat) {
        guard let presentedView = presentedView else { return }

        heightPresentView = height

        UIView.performWithoutAnimation {
            var frame = presentedView.frame
            frame.origin = CGPoint(x: frame.minX, y: self.backdropView.frame.maxY - height)
            frame.size = CGSize(width: frame.width,
                                height: height)
            presentedView.frame = frame
        }
    }
}
