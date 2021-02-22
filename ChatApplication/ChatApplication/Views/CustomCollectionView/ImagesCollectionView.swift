//
//  ImagesCollectionView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/30/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol ImagesCollectionViewDelegate: AnyObject {
    func didOpenImagePicker()
}

class ImagesCollectionView: UIView {

    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        
        cv.registerClassCellFor(type: AddMoreImagesCollectionViewCell.self)
        cv.registerClassCellFor(type: ImageThumbnailRemovableCollectionViewCell.self)
        
        return cv
    }()
    
    lazy var flowLayout:UICollectionViewFlowLayout = {
        let f = UICollectionViewFlowLayout()
        f.scrollDirection = .horizontal
        f.itemSize = CGSize(width: 100.0, height: 100.0)
        f.sectionInset = UIEdgeInsets.init(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        f.minimumInteritemSpacing = 3.0
//        f.minimumLineSpacing = 7.0
        return f
    }()
    
    
    var arrSelectedImages: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    weak var delegate: ImagesCollectionViewDelegate?
    
    var removeImageAt: ((_ index: Int) -> Void)?

    
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


extension ImagesCollectionView: SubviewsLayoutable {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(collectionView)
    }
    
    func setupAutolayoutForSubviews() {
        let margin: CGFloat = Constants.DefaultValues.Size.margin
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin),
            
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0),
            collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0),
            
            ])
    }
    
    func addGestureForSubviews() {

    }
}


//MARK: COLLECTION VIEW DATASOURCE & DELEGATE
extension ImagesCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if arrSelectedImages.count == Constants.limitImagesUploadCount {
//            return Constants.limitImagesUploadCount
//        }
        return arrSelectedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0  {
            let cell = collectionView.dequeueCell(with: AddMoreImagesCollectionViewCell.self, for: indexPath)
            
            return cell
        }
        
        let cell = collectionView.dequeueCell(with: ImageThumbnailRemovableCollectionViewCell.self, for: indexPath)

//        let image = arrSelectedImages.count < Constants.limitImagesUploadCount ? arrSelectedImages[indexPath.row-1] : arrSelectedImages[indexPath.row]
        let image =  arrSelectedImages[indexPath.row-1]
        cell.imgThumb.image = image
//        cell.imageIndex = arrSelectedImages.count < Constants.limitImagesUploadCount ? indexPath.row - 1 : indexPath.row
        cell.imageIndex =  indexPath.row - 1
        cell.removeImageAt = { index in
            self.arrSelectedImages.remove(at: index)
            self.removeImageAt?(index)
        }
//        cell.index = indexPath.row
//        cell.delegate = self

        return cell
    }
    
}

extension ImagesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if indexPath.row == 0 && self.arrSelectedImages.count < Constants.limitImagesUploadCount {
                self.delegate?.didOpenImagePicker()
            }
        }
    }
    
}

extension ImagesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = 100.0
        
        return CGSize.init(width: itemSize, height: itemSize)
    }
}
