//
//  ChatCell.swift
//  ChatApplication-DEV
//
//  Created by Apple on 2/1/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var imageYou: UIImageView!
    @IBOutlet weak var imageMe: UIImageView!
    @IBOutlet weak var backgroundChat: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
