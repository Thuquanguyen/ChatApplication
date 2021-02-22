//
//  RadioCell.swift
//  AIC Utilities People
//
//  Created by toannt on 5/6/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit



class RadioCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var viewRadio: RadioItemView!
    
    var mode: RadioCellMode = .choose {
        didSet {
            viewRadio.mode = mode
        }
    }
    
    var radioItem: RadioItem! {
        didSet {
            viewRadio.radioItem = radioItem
        }
    }

    
    override var isSelected: Bool {
        didSet {
            viewRadio.setState(isActive: isSelected)
        }
    }
}
