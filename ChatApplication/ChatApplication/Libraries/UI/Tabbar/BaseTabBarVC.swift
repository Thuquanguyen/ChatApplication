//
//  BaseTabVC.swift
//
//  Created by DatTran on 6/7/20.
//  Copyright © 2020 Dat Tran. All rights reserved.
//

import UIKit

class BaseTabBarVC: UIViewController {

    @IBOutlet weak var tabHeaderView: BaseCollectionView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightHeaderConstraint: NSLayoutConstraint!
    
    lazy var indicatorView: UIView  = {
        let v = UIView(frame: CGRect(x: 0, y: self.tabSize.height - self.heightIndicator, width: 0, height: 0))
        v.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.8274509804, blue: 0.8352941176, alpha: 1)
        return v
    }()

    var currentIndex: Int {
        return pageView.currentIndex
    }
    
    var maxCache: Int {
        set(value) {
            pageView.maxCache = value
        }
        get {
            return pageView.maxCache
        }
    }
    
    var heightIndicator: CGFloat = 2
    
    var tabSize: CGSize = CGSize(width: 80, height: 70)
    var tabStyle: TabStyle = .fixed
    var tabTextColor = #colorLiteral(red: 0.6352941176, green: 0.737254902, blue: 0.737254902, alpha: 1)
    var tabSelectedTextColor = #colorLiteral(red: 0.1137254902, green: 0.1764705882, blue: 0.2862745098, alpha: 1)
    var tabFont = UIFont.regular(size: 14)
    var tabSelectedFont = UIFont.bold(size: 14)

    var bindingPage: ((_ index: Int) -> UIViewController)? = nil
    var currentPage: ((_ index: Int) -> Void)? = nil
    var dataSourc:[TabbarModel] = []
    let collectionDataSource = CollectionDataSource<TabbarModel, BaseTabBarCell>()
    private let pageView = BasePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderView()
        setupPage()
    }
    
    private func setupPage() {
        pageView.delegateDataSoure = self
        addChild(pageView)
        pageView.view.frame = containerView.bounds
        pageView.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containerView.addSubview(pageView.view)
        pageView.didMove(toParent: self)
    }

    private func setHeaderView() {
        heightHeaderConstraint.constant = tabSize.height
        tabHeaderView.backgroundColor = .white
  
        collectionDataSource.minimumLineSpacing = 0
        collectionDataSource.minimumInteritemSpacing = 0
        tabHeaderView.setup(collectionDataSource, cells: BaseTabBarCell.self)
        collectionDataSource.bindingCell = {[unowned self] cell, data, index  in
            self.bindingCell(cell, index)
            cell.label.text = data.title
            cell.imgAvatar.image = UIImage(named: data.image)
        }
        tabHeaderView.addSubview(indicatorView)
        collectionDataSource.didSelectRowAt = {[weak self]cell, index in
            self?.didTabAction(index: index)
        }
        collectionDataSource.setupData(dataSourc)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        
        let width: CGFloat
        
        switch tabStyle {
        case .fixed:
            width = tabSize.width
        case .fit:
            width = tabHeaderView.bounds.width / CGFloat(numberOfItems())
        default:
            width = 100
        }
        tabSize.width = width
        collectionDataSource.sizeColumn = CGSize(width: width, height: tabSize.height)
        indicatorView.frame.size = CGSize(width: width, height: heightIndicator)
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func didTabAction(index: Int) {
        let indicatorX: CGFloat = CGFloat(index) * tabSize.width
        let offsetTab = calculateOffsetTabHeader(indicatorX: indicatorX)
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.indicatorView.frame.origin.x = indicatorX
        })
        tabHeaderView.setContentOffset(CGPoint(x: offsetTab, y: 0), animated: true)
        pageView.scrollTo(index: index)
    }
    
    func bindingCell(_ cell: BaseTabBarCell, _ index: Int) {
        if index == self.currentIndex {
            cell.label.textColor = tabSelectedTextColor
            cell.label.font = tabSelectedFont
        } else {
            cell.label.textColor = tabTextColor
            cell.label.font = tabFont
        }
    }

    func getViewController(index: Int) -> UIViewController? {
        return pageView.getViewController(index: index)
    }
    
    enum TabStyle {
        case fixed
        case dinamic
        case fit
    }
    
    func reloadData() {
        collectionDataSource.setupData(dataSourc)
        pageView.reloadData()
    }
}

extension BaseTabBarVC: BasePageViewControllerDelegate {
    
    func numberOfItems() -> Int {
        return dataSourc.count
    }
    
    func basePageViewController(index: Int) -> UIViewController {
        return bindingPage?(index) ?? tempViewController()
    }
    
    func basePageViewController(_ scrollView: UIScrollView, offset: CGFloat) {
        if scrollView.isDragging || scrollView.isDecelerating {
            let indicatorX: CGFloat = offset * tabSize.width / scrollView.bounds.width
            let offsetTab = calculateOffsetTabHeader(indicatorX: indicatorX)
            indicatorView.frame.origin.x = indicatorX
            tabHeaderView.setContentOffset(CGPoint(x: offsetTab, y: 0), animated: true)
        }
    }
    
    func calculateOffsetTabHeader(indicatorX: CGFloat) -> CGFloat {
        let width = tabHeaderView.bounds.width
        let offsetTab = max(indicatorX -  width / 2 + tabSize.width / 2, 0)
        return min(offsetTab, max(tabHeaderView.contentSize.width - width, 0))
    }
    
    func basePageViewController(oldSelect: Int, didSelect: Int) {
        currentPage?(didSelect)
        tabHeaderView.reloadCellAt(item: oldSelect)
        tabHeaderView.reloadCellAt(item: didSelect)
    }
    
    private func tempViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        return vc
    }
}
