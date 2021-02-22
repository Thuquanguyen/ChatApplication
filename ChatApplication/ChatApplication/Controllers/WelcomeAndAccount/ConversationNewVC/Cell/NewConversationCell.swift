//
//  NewConversationCell.swift
//  ChatApplication-DEV
//
//  Created by Apple on 2/7/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit

class NewConversationCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.setCorner(userImageView.bounds.width / 2)
    }

    public func configure(with model: SearchResult) {
        userNameLabel.text = model.name

        let path = "images/\(model.email)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }
            case .failure(let error):
                print("failed to get image url: \(error)")
            }
        })
    }
    
}
