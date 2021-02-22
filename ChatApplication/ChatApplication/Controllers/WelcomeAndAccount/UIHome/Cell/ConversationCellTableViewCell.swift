//
//  ConversationCellTableViewCell.swift
//  ChatApplication-DEV
//
//  Created by Apple on 2/1/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    @IBOutlet weak var imageAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageAvatar.setCorner(imageAvatar.bounds.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
