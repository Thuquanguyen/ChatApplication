//
//  AddMoreImagesCollectionViewCell.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/30/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class AddMoreImagesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = Constants.color.light2Color
        v.setCorner(4.0)
        v.set(borderWidth: 1.0, withColor: Constants.color.borderViewGray)
        v.clipsToBounds = true
        return v
    }()
    
    lazy var imgCamera: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage()
        v.set(color: Constants.color.appHighlight)
        v.contentMode = .scaleAspectFit
        //        v.backgroundColor = UIColor.AppColor.appPrimary.withAlphaComponent(0.5) //FOR TEST
        return v
    }()
    
    lazy var lbTitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 1
        v.font = Constants.font.lato(type: .regular, size: 14.0)
        v.textColor = Constants.color.appGrayText
        v.adjustsFontSizeToFitWidth = true
        v.textAlignment = .center
        v.text = ""
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension AddMoreImagesCollectionViewCell: SubviewsLayoutable {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(imgCamera)
        containerView.addSubview(lbTitle)
    }
    
    func setupAutolayoutForSubviews() {
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
            
            imgCamera.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0.0),
            imgCamera.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -13.0),
            imgCamera.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25),
            imgCamera.heightAnchor.constraint(equalTo: imgCamera.widthAnchor, multiplier: 1.0),
            
            lbTitle.topAnchor.constraint(equalTo: imgCamera.bottomAnchor, constant: 10.0),
            lbTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10.0),
            lbTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10.0),

            ])
    }
    
    func addGestureForSubviews() {
        
    }
}

