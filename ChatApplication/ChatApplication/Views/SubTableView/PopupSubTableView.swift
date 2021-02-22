//
//  PopupSubTableView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/22/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

struct PopupSubTableViewCellSection {
    var cellItems: [SubTableViewDataShowable] = []
    var title: String?
}

class PopupSubTableView: UIView {

    // MARK: - Properties
    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.backgroundColor = .white
        v.setCorner(10.0)
        v.setShadowAroundView()
        return v
    }()
    
    lazy var searchView: SearchTextFieldView = {
        let v = SearchTextFieldView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textField.delegate = self
        return v
    }()
    
    lazy var tableView: UITableView = {
        let v = UITableView.init(frame: .zero, style: .plain)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.estimatedRowHeight = UITableView.automaticDimension
        v.rowHeight = UITableView.automaticDimension
        v.dataSource = self
        v.delegate = self
        //        v.tableFooterView = UIView.init(frame: .zero) //remove empty cell
        //        v.separatorStyle = .none
        v.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 30.0, right: 0.0)
        
        v.registerClassCellFor(type: PopupSubTableViewCell.self)
        
        return v
    }()
    
    lazy var btnClose: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(), for: .normal)
        //        v.backgroundColor = .orange //FOR TEST
        return v
    }()
    
    var indexSelected: Int?
    var sourceTag: Int?

    var arrItems: [PopupSubTableViewCellSection] = [] {
        didSet {
            isSearching = false
            searchView.textSearch = nil
            arrSearchResultCellItems.removeAll()
            tableView.reloadData()
            
            arrAllCellItems.removeAll()
            for item in arrItems {
                arrAllCellItems.append(contentsOf: item.cellItems)
            }
        }
    }
    
    var arrAllCellItems: [SubTableViewDataShowable] = []
    
    var arrSearchResultCellItems: [SubTableViewDataShowable] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var textFieldPlaceholder: String? {
        didSet {
            searchView.textFieldPlaceholder = textFieldPlaceholder
        }
    }
    
    var isSearching: Bool = false
    
    // MARK: - Delegates
    weak var delegate: CustomSubTableViewDelegate?
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension PopupSubTableView: SubviewsLayoutable {
    func addSubviews() {
        
        addSubview(containerView)
        containerView.addSubview(searchView)
        containerView.addSubview(tableView)
        addSubview(btnClose)
    }
    
    func setupAutolayoutForSubviews() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8), //0.9
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7), //0.7

//            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
//            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0),
//            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0),
//            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0),
            
            searchView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0),
            searchView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10.0),
            searchView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10.0),
            searchView.heightAnchor.constraint(equalToConstant: 50.0),
            
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10.0),
            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20.0),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0),
            
            btnClose.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0),
            btnClose.leftAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20.0),
            btnClose.widthAnchor.constraint(equalToConstant: 35.0),
            btnClose.heightAnchor.constraint(equalToConstant: 35.0),
            ])
    }
    
    func addGestureForSubviews() {
        btnClose.addTarget(self, action: #selector(pressCloseButton), for: .touchUpInside)
        searchView.textField.addTarget(self, action: #selector(textFieldEditingChange(_:)), for: .editingChanged)
    }
}


//MARK: ACTION
extension PopupSubTableView {
    @objc func pressCloseButton() {
        delegate?.didPressCloseButton()
    }
}


//MARK: UTILITIES
extension PopupSubTableView {
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}


//MARK: UITableViewDatasource
extension PopupSubTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching == false {
            return arrItems.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == false {
            return arrItems[section].cellItems.count
        }
        return arrSearchResultCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: PopupSubTableViewCell.self, for: indexPath)
        
        if isSearching == false {
            let items = arrItems[indexPath.section].cellItems
            let item = items[indexPath.row]
            cell.title = item.title
        } else {
            let item = arrSearchResultCellItems[indexPath.row]
            cell.title = item.title
        }
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension PopupSubTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSearching == false {
            let items = self.arrItems[indexPath.section].cellItems
            let item = items[indexPath.row]
           
        } else {
            let item = self.arrSearchResultCellItems[indexPath.row]
           
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = DefaultTableHeaderView.init(frame: CGRect.zero)
        
        if arrItems.count <= 1 {
            headerView.isHidden = true
        } else if self.isSearching == false {
            headerView.isHidden = false
            let item = self.arrItems[section]
            headerView.title = item.title
        } else {
            headerView.isHidden = true
        }
        
        return headerView
    }
}


//MARK: UITextFieldDelegate
extension PopupSubTableView: UITextFieldDelegate {
    @objc func textFieldEditingChange(_ textField: UITextField) {
        if let updateText = textField.text, updateText.isEmpty == false {
            isSearching = true
            let r = updateText.convertSpecialTextToNormalForSearching()
            arrSearchResultCellItems = arrAllCellItems.filter { $0.title?.convertSpecialTextToNormalForSearching().contains(r) ?? false }
        } else {
            isSearching = false
            arrSearchResultCellItems.removeAll()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


