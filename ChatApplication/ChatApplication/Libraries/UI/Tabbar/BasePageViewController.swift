//
//  BasePageVC.swift
//
//  Created by DatTran on 6/6/20.
//  Copyright © 2020 Dat Tran. All rights reserved.
//

import UIKit

@objc protocol BasePageViewControllerDelegate: NSObjectProtocol {
    
    func numberOfItems() -> Int
    
    func basePageViewController(index: Int) -> UIViewController
    
    @objc optional func basePageViewController(_ scrollView: UIScrollView, offset: CGFloat)
    
    @objc optional func basePageViewController(oldSelect: Int, didSelect: Int)
}

class BasePageViewController: UIPageViewController {
        
    private var count: Int {
        return delegateDataSoure?.numberOfItems() ?? 0
    }
    
    weak var delegateDataSoure: BasePageViewControllerDelegate?

    var currentIndex: Int = 0 {
        didSet {
            if oldValue != currentIndex {
                delegateDataSoure?.basePageViewController?(oldSelect: oldValue, didSelect: currentIndex)
            }
        }
    }
    
    private weak var scrollView:  UIScrollView?
    var maxCache = 5
    private var cacheVC: [Int: UIViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        scrollTo(index: currentIndex)
        scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView
        scrollView?.delegate = self
    }
        
    func nextPage(animated: Bool = true) {
        guard let currentViewController = viewControllers?.first else { return }
        guard let nextViewController = pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func previousPage(animated: Bool = true) {
        guard let currentViewController = viewControllers?.first else { return }
        guard let nextViewController = pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func scrollTo(index: Int, animated: Bool = true) {
        if index < 0 || index  >= count {
            return
        }
        if let vc = getViewController(index: index) {
            vc.view.tag = index
            let direction = index > currentIndex ? NavigationDirection.forward : NavigationDirection.reverse
            currentIndex = index
            cacheVC[index % maxCache] = vc
            setViewControllers([vc], direction: direction, animated: animated, completion: nil)
        }
    }
    
    func addLabel(width: CGFloat, index: Int) -> UILabel {
        let label = UILabel()
        label.text = "Tab \(index)"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: 50)
        return label
    }
    
    func getViewController(index: Int) -> UIViewController? {
        let indexCache = index % maxCache
        if let vc = cacheVC[indexCache], vc.view.tag == index {
            return vc
        } else {
            return delegateDataSoure?.basePageViewController(index: index)
        }
    }
    
    func reloadData() {
        cacheVC.removeAll()
        dataSource = nil
        delegate = nil
        delegate = self
        dataSource = self
        if let vc = getViewController(index: currentIndex) {
            setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        }
    }
}

extension BasePageViewController: UIPageViewControllerDelegate,  UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let view = viewController.view else { return nil }
        var index = view.tag
    
        if index > 0  {
            index -= 1
            let indexCache = index % maxCache
            if let vc = cacheVC[indexCache] , vc.view.tag == index {
                return vc
            }
            if let vc = delegateDataSoure?.basePageViewController(index: index) {
                vc.view.tag = index
                cacheVC[indexCache] = vc
                return vc
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let view = viewController.view else { return nil }
        var index = view.tag
        if index < count - 1 {
            index += 1
            let indexCache = index % maxCache
            if let vc = cacheVC[indexCache] , vc.view.tag == index {
                return vc
            }
            if let vc = delegateDataSoure?.basePageViewController(index: index) {
                vc.view.tag = index
                cacheVC[indexCache] = vc
                return vc
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        currentIndex = viewControllers!.first!.view.tag
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let offset = scrollView.contentOffset.x + width * CGFloat(currentIndex - 1)
        if offset > width * CGFloat(count - 1) {
            return
        }
        delegateDataSoure?.basePageViewController?(scrollView, offset: offset)
   
    }
}
