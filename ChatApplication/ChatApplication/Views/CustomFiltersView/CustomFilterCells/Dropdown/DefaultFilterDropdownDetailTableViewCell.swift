//
//  DefaultFilterDropdownDetailTableViewCell.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class DefaultFilterDropdownDetailTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    // MARK: - Properties
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(_ item: DataFilterDetail) {
        if item.selected {
            icon = UIImage()
        } else {
            icon = UIImage()
        }
        if let it = item.item {
            title = it.title
        } else {
            title =  ""
        }
    }
    
}
