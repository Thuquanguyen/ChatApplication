//
//  SelfSizingTableView.swift
//  AIC Utilities People
//
//  Created by Linh Ta on 8/27/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class SelfSizingTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        
        let height = min(contentSize.height, CGFloat.infinity)
        return CGSize(width: contentSize.width, height: height)
    }
}

