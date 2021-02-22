//
//  CustomSubTableView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/14/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol CustomSubTableViewDelegate: AnyObject {
    func didPressCloseButton()
}

class CustomSubTableView: UIView {
    
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
        v.tableFooterView = UIView.init(frame: .zero) //remove empty cell
//        v.separatorStyle = .none
        v.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 30.0, right: 0.0)
        
        v.registerClassCellFor(type: PopupSubTableViewCell.self)
        
        return v
    }()
    
    lazy var lbNotFound: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = Constants.font.lato(type: .regular, size: 15.0)
        v.textColor = Constants.color.appGrayText
        v.text = ""
        v.textAlignment = .center
        v.isHidden = true
        return v
    }()
    
    lazy var btnClose: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .orange //FOR TEST
        return v
    }()
    
    var indexSelected: Int?
    var sourceTag: Int?

    var arrResults: [SubTableViewDataShowable] = [] {
        didSet {
            isSearching = false
            searchView.textSearch = nil
            arrSearchResults.removeAll()
            tableView.reloadData()
        }
    }
    
    var arrSearchResults: [SubTableViewDataShowable] = [] {
        didSet {
            if arrSearchResults.isEmpty == true, isSearching == true {
                lbNotFound.isHidden = false
                tableView.alwaysBounceVertical = false
            } else {
                lbNotFound.isHidden = true
                tableView.alwaysBounceVertical = true
            }
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


extension CustomSubTableView: SubviewsLayoutable {
    func addSubviews() {
        
        addSubview(containerView)
        containerView.addSubview(searchView)
        containerView.addSubview(tableView)
        addSubview(btnClose)
        containerView.addSubview(lbNotFound)
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
            
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 20.0),
            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10.0),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20.0),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10.0),
            
            lbNotFound.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 50.0),
            lbNotFound.leftAnchor.constraint(equalTo: searchView.leftAnchor),
            lbNotFound.rightAnchor.constraint(equalTo: searchView.rightAnchor),
            
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
extension CustomSubTableView {
    @objc func pressCloseButton() {
        delegate?.didPressCloseButton()
    }
}


//MARK: UTILITIES
extension CustomSubTableView {
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}


//MARK: UITableViewDatasource
extension CustomSubTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == false {
            return arrResults.count
        }
        return arrSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: PopupSubTableViewCell.self, for: indexPath)
        
        if isSearching == false {
            let result = arrResults[indexPath.row]
            cell.title = result.title
        } else {
            let result = arrSearchResults[indexPath.row]
            cell.title = result.title
        }
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension CustomSubTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSearching == false {
            let result = self.arrResults[indexPath.row]
           
        } else {
            let result = self.arrSearchResults[indexPath.row]
        }
    }
}


//MARK: UITextFieldDelegate
extension CustomSubTableView: UITextFieldDelegate {
    @objc func textFieldEditingChange(_ textField: UITextField) {
        if let updateText = textField.text, updateText.isEmpty == false {
            isSearching = true
            let r = updateText.convertSpecialTextToNormalForSearching()
            arrSearchResults = arrResults.filter { $0.title?.convertSpecialTextToNormalForSearching().contains(r) ?? false }
        } else {
            isSearching = false
            arrSearchResults.removeAll()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


