//
//  BackgroundView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/23/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class BackgroundView: UIView {

    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    lazy var imgBackground: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleToFill
        v.backgroundColor = .clear
        v.clipsToBounds = true
        return v
    }()
    
    var image: UIImage? {
        didSet {
            imgBackground.image = image
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


extension BackgroundView: SubviewsLayoutable {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(imgBackground)
    }
    
    func setupAutolayoutForSubviews() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.0),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.0),
            
            imgBackground.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            imgBackground.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0),
            imgBackground.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0),
            imgBackground.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0),
            
            ])
    }
    
    func addGestureForSubviews() {

    }
}
