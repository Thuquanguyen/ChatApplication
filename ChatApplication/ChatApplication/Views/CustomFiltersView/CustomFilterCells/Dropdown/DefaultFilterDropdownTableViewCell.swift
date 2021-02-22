//
//  DefaultFilterDropdownTableViewCell.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol DefaultFilterDropdownTableViewCellDelegate: AnyObject {
    func didTapBoxView(index: Int)
}

class DefaultFilterDropdownTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var imgDropdown: UIImageView!
    
    // MARK: - Properties
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }
    
    var content: String? {
        didSet {
            lbContent.text = content
        }
    }
    
    var index: Int?
    var isDisable: Bool = false {
        didSet {
            disableCell(isDisbale: isDisable)
            if isDisable {
                boxView.isUserInteractionEnabled = false
            } else {
                boxView.addSingleTapGesture(target: self, selector: #selector(tapToBoxView))
            }
        }
    }
    
    // MARK: - Delegates
    weak var delegate: DefaultFilterDropdownTableViewCellDelegate?
    
    // MARK: - View's life cycles
    override func awakeFromNib() {
        super.awakeFromNib()

        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension DefaultFilterDropdownTableViewCell: SubviewsLayoutable {
    func addSubviews() {
        
    }
    
    func setupAutolayoutForSubviews() {
        
    }
    
    func addGestureForSubviews() {
        
    }
    
    
}



extension DefaultFilterDropdownTableViewCell {
    func disableCell(isDisbale: Bool) {
        if isDisbale == true {
//            lbTitle.textColor = Constants.color.lightColor
            imgDropdown.set(color: Constants.color.lightColor)
            lbContent.textColor = Constants.color.lightColor
        } else {
//            lbTitle.textColor = Constants.color.appDefaultText
            imgDropdown.set(color: Constants.color.grayColor)
            lbContent.textColor = Constants.color.appDefaultText
        }
    }
    
    @objc func tapToBoxView() {
        if isDisable == false {
            delegate?.didTapBoxView(index: index ?? 0)
        }
    }
}
