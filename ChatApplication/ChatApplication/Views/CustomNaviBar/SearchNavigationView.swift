//
//  SearchNavigationView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/12/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class SearchNavigationView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var leftButtonView: UIView!
    @IBOutlet weak var imgLeft: UIImageView!
    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var separateView: UIView!
    
    // MARK: - Delegates
    weak var delegate: NavigationActionable?

    // MARK: - Properties
    var placeholder: String? {
        didSet {
            searchBarView.placeholder = placeholder
        }
    }
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "SearchNavigationView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
        
        self.backgroundColor = .white
    }
    
    func hideSeparateView() {
        separateView.isHidden = true
    }
    
}


extension SearchNavigationView: SubviewsLayoutable {
    func addSubviews() {
        
    }
    
    func setupAutolayoutForSubviews() {
        
    }
    
    func addGestureForSubviews() {
        leftButtonView.addSingleTapGesture(target: self, selector: #selector(pressBack))
    }
    
    func customNaviViewForVNAirlines() {
        self.backgroundColor = Constants.color.VNAirlineGreenColor
        self.searchBarView.backgroundColor = .clear
        self.searchBarView.textFieldSearch.tintColor = .white
        self.searchBarView.textFieldSearch.textColor = .white
        self.searchBarView.imageIconSearch.set(color: .white)
        self.searchBarView.imageIconRight.set(color: .white)
        self.searchBarView.textFieldSearch.attributedPlaceholder = NSAttributedString(string: "Tìm kiếm địa điểm...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.imgLeft.set(color: .white)        
    }
}


//MARK: ACTION
extension SearchNavigationView {
    @objc func pressBack() {
        if let delegate = self.delegate {
            delegate.didPressLeftButton()
        } else {
            VCService.pop()
        }
    }
}
