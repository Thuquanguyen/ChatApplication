//
//  SearchFilterView.swift
//  AIC Utilities People
//
//  Created by Tà Truhoada on 05.08.19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class SearchFilterView: UIView {

    // MARK: - Properties
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
    
    var rightSearchViewConstraint: NSLayoutConstraint?
    
    // MARK: - Closures
    var didPressFilter: (() -> ())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = .white
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
}


extension SearchFilterView: SubviewsLayoutable {
    func addSubviews() {
        addSubview(searchView)
        addSubview(filterButtonView)
    }
    
    func setupAutolayoutForSubviews() {
        let margin: CGFloat = Constants.DefaultValues.Size.margin
        let textFieldHeight: CGFloat = 50.0
        let filterButtonHeight: CGFloat = 40.0
        
        rightSearchViewConstraint = searchView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3.0*margin - filterButtonHeight)
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            searchView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3.0*margin),
            searchView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
            //            searchView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3.0*margin),
            searchView.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            filterButtonView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: 0.0),
            filterButtonView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2.0*margin),
            filterButtonView.heightAnchor.constraint(equalToConstant: filterButtonHeight),
            filterButtonView.widthAnchor.constraint(equalToConstant: filterButtonHeight),
            
            rightSearchViewConstraint!
            ])
    }
    
    func addGestureForSubviews() {
        filterButtonView.addSingleTapGesture(target: self, selector: #selector(pressFilter))
    }
}


extension SearchFilterView {
    @objc func pressFilter() {
        didPressFilter?()
    }
}

