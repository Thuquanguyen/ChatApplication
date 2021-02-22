//
//  ConversationGroupCell.swift
//  ChatApplication-DEV
//
//  Created by ThuNQ on 2/9/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {

    enum bubbleType {
        case incoming
        case outgoing
    }

    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var chatStack: UIStackView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewBubbleView: UIView!
    
    @IBOutlet weak var senderNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBubbleDataForMessage(message: MessageModel){
        if(message.messageText != nil) {
            self.textView.text = message.messageText
            self.imageView?.isHidden = true
            self.textView.isHidden = false
        } else if(message.imageLink != nil){
            self.imageView?.isHidden = false
            self.textView.isHidden = true
//            self.imageContent.sd_setImage(with: URL(string: message.imageLink ?? ""), placeholderImage: UIImage(named: "icon_none"))
            self.imageContent.sd_setImage(with: URL(string: message.imageLink ?? ""), completed: nil)
        }
        
        self.senderNameLabel.text = message.senderUsername
    }

    func setBubbleType(type: bubbleType){
        if(type == .outgoing){
            print("incoming !")
            self.chatStack.alignment = .trailing
            self.textViewBubbleView.backgroundColor = #colorLiteral(red: 0.059805127, green: 0.2340934603, blue: 0.245598033, alpha: 1)
            self.textView.textColor = UIColor.white
            
        } else if(type == .incoming){
            self.chatStack.alignment = .leading
            self.textViewBubbleView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.textView.textColor = UIColor.black

        }
    }
    
}
