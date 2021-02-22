//
//  UITableViewHeaderFooterView+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 2/19/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

// MARK: - UITableHeaderFooterView
protocol XibTableHeaderFooterView {
    static var name: String { get }
    static func registerHeaderFooterTo(tableView: UITableView)
    static func reusableHeaderFooterFor(tableView: UITableView) -> Self?
}

extension XibTableHeaderFooterView where Self: UITableViewHeaderFooterView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last ?? ""
    }
    
    static func registerHeaderFooterTo(tableView: UITableView) {
        tableView.register(Self.self, forHeaderFooterViewReuseIdentifier: name)
    }
    
    static func reusableHeaderFooterFor(tableView: UITableView) -> Self? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: name) as? Self
    }
}

extension UITableViewHeaderFooterView: XibTableHeaderFooterView { }

public extension UITableView {
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
}
