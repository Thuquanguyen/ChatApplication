//
//  SearchFilterSectionHeaderView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/24/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class SearchFilterSectionHeaderView: UITableViewHeaderFooterView {

    lazy var searchView: SearchTextFieldView = {
        let v = SearchTextFieldView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textFieldPlaceholder = "L10n.Optionselect.searchPlaceholder"
        return v
    }()
    
    lazy var filterButtonView: DefaultFilterEntryButtonView = {
        let v = DefaultFilterEntryButtonView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var textFieldPlaceholder: String? {
        didSet {
            searchView.textFieldPlaceholder = textFieldPlaceholder
        }
    }
    
    var didPressFilter: (() -> ())?
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SearchFilterSectionHeaderView: SubviewsLayoutable {
    func addSubviews() {
        addSubview(searchView)
        addSubview(filterButtonView)
    }
    
    func setupAutolayoutForSubviews() {
        let margin: CGFloat = Constants.DefaultValues.Size.margin
        let textFieldHeight: CGFloat = 50.0
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            searchView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3.0*margin),
            searchView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
            //            searchView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3.0*margin),
            searchView.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            filterButtonView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: 0.0),
            filterButtonView.leftAnchor.constraint(equalTo: searchView.rightAnchor, constant: 8.0),
            filterButtonView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2.0*margin),
            filterButtonView.heightAnchor.constraint(equalToConstant: 40.0),
            filterButtonView.widthAnchor.constraint(equalToConstant: 40.0),
            
            ])
    }
    
    func addGestureForSubviews() {
        filterButtonView.addSingleTapGesture(target: self, selector: #selector(pressFilter))
    }
}


extension SearchFilterSectionHeaderView {
    @objc func pressFilter() {
        didPressFilter?()
    }
}

