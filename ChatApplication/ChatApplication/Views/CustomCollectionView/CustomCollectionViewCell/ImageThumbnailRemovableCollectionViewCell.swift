//
//  ImageThumbnailRemovableCollectionViewCell.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/30/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class ImageThumbnailRemovableCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    lazy var imgThumb: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.image = Asset.Image_Add_Images.image
        v.contentMode = .scaleAspectFill
        //        v.backgroundColor = UIColor.AppColor.appPrimary.withAlphaComponent(0.5) //FOR TEST
        v.setCorner(4.0)
        v.set(borderWidth: 1.0, withColor: Constants.color.borderViewGray)
        v.clipsToBounds = true
        return v
    }()
    
    lazy var closeView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear //FOR TEST
        return v
    }()
    
    lazy var imgClose: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage()
        v.contentMode = .scaleAspectFit
        //        v.backgroundColor = UIColor.AppColor.appPrimary.withAlphaComponent(0.5) //FOR TEST
        return v
    }()
    
    var imageIndex: Int = 0
    
    // MARK: - Closures
    var removeImageAt: ((_ index: Int) -> Void)?
    
    
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


extension ImageThumbnailRemovableCollectionViewCell: SubviewsLayoutable {
    func addSubviews() {
        addSubview(imgThumb)
        addSubview(closeView)
        closeView.addSubview(imgClose)
    }
    
    func setupAutolayoutForSubviews() {
        
        NSLayoutConstraint.activate([
            imgThumb.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            imgThumb.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            imgThumb.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            imgThumb.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
            
            closeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            closeView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
            closeView.widthAnchor.constraint(equalToConstant: 40.0),
            closeView.heightAnchor.constraint(equalToConstant: 40.0),
            
            imgClose.topAnchor.constraint(equalTo: closeView.topAnchor, constant: 5.0),
            imgClose.rightAnchor.constraint(equalTo: closeView.rightAnchor, constant: -5.0),
            imgClose.widthAnchor.constraint(equalToConstant: 20.0),
            imgClose.heightAnchor.constraint(equalToConstant: 20.0),
            
            ])
    }
    
    func addGestureForSubviews() {
        closeView.addSingleTapGesture(target: self, selector: #selector(pressRemoveImage))
    }
}

extension ImageThumbnailRemovableCollectionViewCell {
    @objc func pressRemoveImage() {
        removeImageAt?(imageIndex)
    }
}

