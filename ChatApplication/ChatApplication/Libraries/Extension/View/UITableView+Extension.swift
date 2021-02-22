//
//  UITableView+Extension.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/9/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

extension UITableView {
    func set(delegateAndDataSource: UITableViewDataSource & UITableViewDelegate) {
        delegate = delegateAndDataSource
        dataSource = delegateAndDataSource
    }
    
    func registerNibCellFor<T: UITableViewCell>(type: T.Type) {
        let nibName = type.name
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func registerClassCellFor<T: UITableViewCell>(type: T.Type) {
        let nibName = type.name
        register(type, forCellReuseIdentifier: nibName)
    }
    
    func registerNibHeaderFooterFor<T: UIView>(type: T.Type) {
        let nibName = type.name
        register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    func registerClassHeaderFooterFor<T: UIView>(type: T.Type) {
        let nibName = type.name
        register(type, forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    // MARK: - Get component functions
    func reusableCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath? = nil) -> T? {
        let nibName = type.name
        if let indexPath = indexPath {
            return self.dequeueReusableCell(withIdentifier: nibName, for: indexPath) as? T
        }
        return self.dequeueReusableCell(withIdentifier: nibName) as? T
    }
    
    func cell<T: UITableViewCell>(type: T.Type, section: Int, row: Int) -> T? {
        guard let indexPath = validIndexPath(section: section, row: row) else { return nil }
        return self.cellForRow(at: indexPath) as? T
    }
    
    func reusableHeaderFooterFor<T: UIView>(type: T.Type) -> T? {
        let nibName = type.name
        return self.dequeueReusableHeaderFooterView(withIdentifier: nibName) as? T
    }
    
    func tableHeader<T: UIView>(type: T.Type) -> T? {
        return tableHeaderView as? T
    }
    
    func tableFooter<T: UIView>(type: T.Type) -> T? {
        return tableFooterView as? T
    }
    
    // MARK: - UI functions
    func scrollToTop(animated: Bool = true) {
        setContentOffset(.zero, animated: animated)
    }
    
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastRowNumber = numberOfRows(inSection: numberOfSections - 1)
        guard lastRowNumber > 0 else { return }
        let indexPath = IndexPath(row: lastRowNumber - 1, section: numberOfSections - 1)
        scrollToRow(at: indexPath, at: .top, animated: animated)
    }
    
    func reloadCellAt(section: Int = 0, row: Int) {
        if let indexPath = validIndexPath(section: section, row: row) {
            reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func reloadSectionAt(index: Int) {
        reloadSections(IndexSet(integer: index), with: .fade)
    }
    
    func change(bottomInset value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    // MARK: - Supporting functions
    func validIndexPath(section: Int, row: Int) -> IndexPath? {
        guard section >= 0 && row >= 0 else { return nil }
        let rowCount = numberOfRows(inSection: section)
        guard rowCount > 0 && row < rowCount else { return nil }
        return IndexPath(row: row, section: section)
    }
    
    //MARK: Update TableHeaderView height
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }
}

extension UITableView {
    ///You need to manually call reloadData() to show/hide the message
    func showEmptyMessageFooterIfNeeded(modelCount: Int) {
        guard modelCount == 0 else {
            tableFooterView = nil
            return
        }
        
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        emptyLabel.text = "Không có nội dung tương ứng"
        emptyLabel.font = UIFont(name: "Lato", size: 16)
        emptyLabel.textColor = Constants.color.appDefaultText
        emptyLabel.textAlignment = .center
        tableFooterView = emptyLabel
    }
    
    func addLargeTitleHeader(titleName: String) {
        let header = LargeTitleHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.lbTitle.text = titleName
        header.updateTitleConstraint(topOffset: 24, leadingOffset: 0, trailingOffset: 16, bottomOffset: 24)
        
        let headerRect = CGRect(origin: .zero, size: header.systemLayoutSizeFitting(CGSize(width: CGFloat.infinity, height: CGFloat.infinity)))
        let containerView = UIView(frame: headerRect)
        
        containerView.addSubview(header)
        header.constraintToAllSides(of: containerView)
        
        tableHeaderView = containerView
    }
}


extension UITableView {
    func showEmptyMessage(_ message: String = "Không có nội dung tương ứng") {
        self.backgroundView = nil
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        view.backgroundColor = .white
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 100.0))
        messageLabel.text = message
        messageLabel.textColor = Constants.color.appGrayText
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = Constants.font.lato(type: .medium, size: 15)
        
        view.addSubview(messageLabel)

        self.backgroundView = view
    }

    func hideEmptyMessage() {
        self.backgroundView = nil
    }
}
