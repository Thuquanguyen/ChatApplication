//
//  DefaultTableHeaderView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/22/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class DefaultTableHeaderView: UIView {

    // MARK: - Properties
    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Constants.color.light2Color
        return v
    }()
    
    lazy var lbSectionTitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = Constants.color.darkColor
        v.font = Constants.font.lato(type: .bold, size: 15.0)
        v.textAlignment = .left
        v.numberOfLines = 0
//        v.adjustsFontSizeToFitWidth = true
        return v
    }()
    
    var title: String? {
        didSet {
            lbSectionTitle.text = title?.uppercased()
        }
    }
    
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


extension DefaultTableHeaderView: SubviewsLayoutable {
    func addSubviews() {
        self.addSubview(containerView)
        containerView.addSubview(lbSectionTitle)
    }
    
    func setupAutolayoutForSubviews() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
            
            lbSectionTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0),
            lbSectionTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10.0),
            lbSectionTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10.0),
            lbSectionTitle.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5.0),
            
            ])
    }
    
    func addGestureForSubviews() {
        
    }
}
