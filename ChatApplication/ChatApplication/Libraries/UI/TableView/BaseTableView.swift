//
//  BaseTableView.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {
            
    // MARK: - Closure
    var didChangeContentSize: ((_ size: CGSize) -> Void)?
    var notifyIfNoData = false
    var textNotify = "Không có dữ liệu tương ứng"
    private var label: UILabel?
    private var indicatorView: UIActivityIndicatorView?
    private var mTimer: Timer?
    
    var isLoading = false {
        didSet {
            setShowLoading(isLoading)
        }
    }
    var loadMoreData: (() -> Void)? {
        didSet {
            addLoadingView()
        }
    }
    // MARK: - Override functions
    override var contentSize: CGSize {
        didSet {
            didChangeContentSize?(contentSize)
        }
    }
    
    override var contentOffset: CGPoint {
        didSet {
            handleScroll()
        }
    }
    
    
    deinit {
        mTimer?.invalidate()
    }
    
    // MARK: - Register functions
    func setup(input: UITableViewDataSource & UITableViewDelegate) {
        delegate = input
        dataSource = input
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    func scrollToLastRow(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastRowNumber = numberOfRows(inSection: numberOfSections - 1)
        guard lastRowNumber > 0 else { return }
        let indexPath = IndexPath(row: lastRowNumber - 1, section: numberOfSections - 1)
        
        if self.indexPathExists(indexPath: indexPath) {
            scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
    
    func set(source: UITableViewDataSource,  registerNibCells: [UITableViewCell.Type]) {
        dataSource = source
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutMargins = UIEdgeInsets.zero
        separatorStyle = .none
        allowsSelection = true
        backgroundColor = UIColor.clear
        if tableFooterView == nil {
            tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
        }
        registerNibCells.forEach {
            registerNibCellFor(type: $0)
        }
    }
    
    func setup(source: UITableViewDataSource & UITableViewDelegate,  registerNibCells: [UITableViewCell.Type]) {
        delegate = source
        self.set(source: source, registerNibCells: registerNibCells)
    }
    
    func setupSeparator(color: UIColor = #colorLiteral(red: 0.8156862745, green: 0.8705882353, blue: 0.8705882353, alpha: 1), marginLeft: CGFloat = 16, marginRight: CGFloat = 16)  {
        separatorStyle = .singleLine
        separatorInset = UIEdgeInsets(top: 0, left: marginLeft, bottom: 0, right: marginRight)
        separatorColor = color
    }
    
    override func reloadData() {
        super.reloadData()
        if notifyIfNoData {
            if label == nil {
                let lb = UILabel(frame: CGRect(x: 0, y: 50, width: width, height: 40))
                label = lb
                lb.textAlignment = .center
                lb.textColor = #colorLiteral(red: 0.1137254902, green: 0.1764705882, blue: 0.2862745098, alpha: 1)
                lb.font = UIFont.regular(size: 18)
                addSubview(lb)
                lb.text = textNotify
            }
            label?.isHidden = numberOfRows(inSection: 0) != 0
        }
    }
    
    
    private func addLoadingView() {
        if indicatorView == nil {
            let view = UIActivityIndicatorView(style: .gray)
            indicatorView = view
            let size = CGRect(x: CGFloat(0), y: CGFloat(0), width: bounds.width, height: CGFloat(54))
            view.frame = size
            view.isHidden = true
            tableFooterView = view
        }
    }
    
    private func handleScroll() {
        guard loadMoreData != nil else { return }
        if contentOffset.y > 0 {
            if !isLoading && contentSize.height - (height + contentOffset.y) < 54 {
                isLoading = true
                mTimer?.invalidate()
                mTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: {[weak self] t in
                    self?.loadMoreData?()
                })
            }
        } else {
            //TODO refresh data
        }
        
    }
    
    func setShowLoading(_ show: Bool) {
        if show {
            indicatorView?.startAnimating()
            indicatorView?.isHidden = false
        } else {
            indicatorView?.stopAnimating()
            indicatorView?.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
}


extension UITableView {
    func indexPathExists(indexPath:IndexPath) -> Bool {
        if indexPath.section >= self.numberOfSections {
            return false
        }
        if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }
}

class BaseTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        selectionStyle = .none
    }
}
