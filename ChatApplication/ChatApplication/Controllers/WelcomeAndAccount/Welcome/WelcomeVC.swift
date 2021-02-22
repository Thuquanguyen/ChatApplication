//
//  WelcomeVC.swift
//  YTeThongMinh
//
//  Created by QuanNH on 5/27/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var basePageView: UIView!
    
    // MARK: - Properties
    var page: UIPageViewController!
    var imageNames: [String] = ["icon_splat_1","icon_splat_2","icon_splat_3"]
    var imageLines: [String] = ["icon_line_1","icon_line_2","icon_line_3"]
    var titleNames:[String] = ["Cập nhật\nmọi lúc, mọi nơi","Giao tiếp dễ dàng\nnhanh chóng","Rút ngắn thời gian\nLàm việc hiệu quả"]
    var indexPage = 0
    static var timer: Timer?
    
    // MARK: - ViewController's life cycles
    deinit {
        WelcomeVC.timer?.invalidate()
        WelcomeVC.timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupPage()
        setupTimer()
    }
    
    func setupVC(){
        buttonStart.layer.cornerRadius = 20
    }
    
    func setupPage(){
        page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        page.dataSource = self
        page.delegate = self
        if let view = page.view {
            basePageView.addSubview(view)
        }
        page.view.frame = CGRect(x: 0, y: 0, width: basePageView.width, height: basePageView.height)
        page.setViewControllers([getPage(index: 0) ?? UIViewController()], direction: .forward, animated: false, completion: nil)
    }
    
    func setupTimer(){
        WelcomeVC.timer?.invalidate()
        WelcomeVC.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] (timer) in
            var index = (self?.indexPage ?? 0) + 1
            var direction = UIPageViewController.NavigationDirection.forward
            direction = index >= 3 ? .reverse : .forward
            index = index >= 3 ? 0 : index
            self?.page.setViewControllers([self?.getPage(index: index) ?? UIViewController()], direction: direction, animated: true, completion: nil)
            self?.indexPage = index
            self?.buttonStart.isHidden = index != 2
        })
    }
    
    @IBAction func buttonContinue(_ sender: Any) {
        AppDelegate.shared.makeLogin()
    }
    
}

// MARK: - UIPageViewController Delegate
extension WelcomeVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func getPage(index: Int) -> WelcomePageVC? {
        if index == -1 || index == imageNames.count {
            return nil
        }
        let vc = WelcomePageVC()
        vc.index = index
        if imageNames.count > index {
            vc.image = UIImage(imageNames[index])
            vc.titleSplat = titleNames[index]
            vc.line = imageLines[index]
        }
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = (viewController as? WelcomePageVC) {
            return getPage(index: vc.index - 1)
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vc = (viewController as? WelcomePageVC) {
            return getPage(index: vc.index + 1)
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if let vc = pageViewController.viewControllers?.first {
                if let index = (vc as? WelcomePageVC)?.index {
                    setupTimer()
                    indexPage = index
                    buttonStart.isHidden = index != 2
                }
            }
        }
    }
}
