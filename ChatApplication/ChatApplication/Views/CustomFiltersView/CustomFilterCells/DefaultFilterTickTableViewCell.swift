//
//  DefaultFilterTickTableViewCell.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/7/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class DefaultFilterTickTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imgLeftIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgRightIcon: UIImageView!
    @IBOutlet weak var leadingContentConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }
    
    var iconLeft: UIImage? {
        didSet {
            imgLeftIcon.image = iconLeft
        }
    }
    
    var iconRight: UIImage? {
        didSet {
            imgRightIcon.image = iconRight
        }
    }
    
    var filterCellTick: FilterCellTick? {
        didSet {
            title = filterCellTick?.title
            iconLeft = filterCellTick?.icon
            leadingContentConstraint.constant = filterCellTick?.icon == nil ? 24.0 : 64.0
            if filterCellTick?.indexSelecteds.isEmpty ?? true {
                iconRight = "Image_Tick_Unselected".image
                imgRightIcon.set(color: UIColor("C9CAD0"))
            } else {
                iconRight = "Image_Tick_Selected".image
                imgRightIcon.set(color: Constants.color.appHighlight)
            }
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
    
}
