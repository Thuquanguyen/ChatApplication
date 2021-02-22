//
//  ConversationCell.swift
//  ChatApplication-DEV
//
//  Created by Apple on 2/7/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit

class ConversationTableCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.setCorner(userImageView.bounds.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(with model: Conversation) {
        userMessageLabel.text = model.latestMessage.text
        userNameLabel.text = model.name

        let path = "images/\(model.otherUserEmail)_profile_picture.png"
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
    
    @IBAction func actionShowProfile(_ sender: Any) {
        let vc = ProfileVC()
        parentViewController?.push(vc)
    }
}
