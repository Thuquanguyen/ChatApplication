//
//  BaseCollectionView.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/9/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

class BaseCollectionView: UICollectionView {
    
    // This work in ios 12 to 12.2 for tags list
    private var shouldInvalidateLayout = false

    // MARK: - Closure
    var didChangeContentSize: ((_ size: CGSize) -> Void)?
    
    // MARK: - Override functions
    override var contentSize: CGSize {
        didSet {
            didChangeContentSize?(contentSize)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldInvalidateLayout {
            collectionViewLayout.invalidateLayout()
            shouldInvalidateLayout = false
        }
    }

    override func reloadData() {
        shouldInvalidateLayout = true
        super.reloadData()
    }
}
