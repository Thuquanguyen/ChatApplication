//
//  TableDataSource.swift
//  AICPeople-DEV
//
//  Created by Dat Tran on 4/10/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import UIKit

class TableDataSource<T, C: UITableViewCell>: NSObject,  UITableViewDataSource, UITableViewDelegate {
        
    var data: [T]
    private weak var mTableView: UITableView?
    var height: CGFloat
    var didSelectRowAt: ((_ data: T, _ row: Int) -> Void)?
    var bindingCell: ((_ cell: C, _ data: T, _ row: Int) -> Void)?
    var marginBottom: CGFloat = 0
    
    weak var headerView: UIView?
    var heightForHeader: CGFloat = 0
    var pageNumber = 1
    
    init(data: [T] = [], height: CGFloat = UITableView.automaticDimension) {
        self.data = data
        self.height = height
    }
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mTableView = tableView
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: C.self, for: indexPath)
        bindingCell?(cell, data[indexPath.row], indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt?(data[indexPath.row], indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return marginBottom
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView ?? UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
    }

    func setupData(_ data:  [T]) {
        self.data = data
        pageNumber = 1
        mTableView?.reloadData()
    }
    
    func addItems(_ data:  T...) {
        self.data += data
        mTableView?.reloadData()
    }
    
    func addData(_ data:  [T]) {
        if !data.isEmpty {
            self.data += data
            pageNumber += 1
            mTableView?.reloadData()
        }
    }
    
    var count: Int {
        return data.count
    }
    
    func remove() {
        data.removeAll()
        pageNumber = 1
        mTableView?.reloadData()
    }
    
    func remove(index: Int) {
        data.remove(at: index)
        reloadData()
    }
    
    func reloadData()  {
        mTableView?.reloadData()
    }

    subscript(_ index: Int) -> T {
        return data[index]
    }
}
