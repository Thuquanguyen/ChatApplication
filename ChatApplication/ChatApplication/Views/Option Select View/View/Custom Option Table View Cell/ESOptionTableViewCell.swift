//
//  ESOptionTableViewCell.swift
//  E-Office
//
//  Created by VietHD-D3 on 4/8/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class ESOptionTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imvCheckBox: UIImageView!
    @IBOutlet weak var lblFieldTitle: UILabel!
    
    // MARK: - View's life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setItemTitleAndSelectState(title: String, isSelected: Bool) {
//        imvCheckBox.image = UIImage(named: isSelected ? Asset.icCheckedBox.name : Asset.icUncheckBox.name)
        lblFieldTitle.text = title
    }
    
}
