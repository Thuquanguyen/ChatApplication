//
//  IconSubtitleView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/16/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class IconSubtitleView: UIView {
    
    lazy var lbTitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 2
        v.font = Constants.font.lato(type: .regular, size: 13.0)
        v.textColor = Constants.color.appGrayText
        //        v.adjustsFontSizeToFitWidth = true
        return v
    }()
    
    lazy var imgIcon: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .clear
        v.clipsToBounds = true
        return v
    }()
    
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }
    
    var icon: UIImage? {
        didSet {
            imgIcon.image = icon
        }
    }
    
    
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

extension IconSubtitleView: SubviewsLayoutable {
    func addSubviews() {
        addSubview(imgIcon)
        addSubview(lbTitle)
    }
    
    func setupAutolayoutForSubviews() {
        NSLayoutConstraint.activate([
            imgIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            imgIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            imgIcon.heightAnchor.constraint(equalToConstant: 15.0),
            imgIcon.widthAnchor.constraint(equalToConstant: 15.0),
            imgIcon.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 0.0),
            
            lbTitle.topAnchor.constraint(equalTo: imgIcon.topAnchor, constant: 0.0),
            lbTitle.leftAnchor.constraint(equalTo: imgIcon.rightAnchor, constant: 10.0),
            lbTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
            lbTitle.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 0.0),
            
        ])
    }
    
    func addGestureForSubviews() {
        
    }
}

