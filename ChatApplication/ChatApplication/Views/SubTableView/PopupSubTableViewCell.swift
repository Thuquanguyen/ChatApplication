//
//  PopupSubTableViewCell.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/22/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class PopupSubTableViewCell: UITableViewCell {

    // MARK: - Proterties
    lazy var lbTitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = Constants.font.lato(type: .regular, size: 17.0)
        v.textColor = Constants.color.appDefaultText
        return v
    }()
    
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }

    // MARK: - View's life cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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


extension PopupSubTableViewCell: SubviewsLayoutable {
    func addSubviews() {
        addSubview(lbTitle)
    }
    
    func setupAutolayoutForSubviews() {
        let margin: CGFloat = Constants.DefaultValues.Size.margin
        
        NSLayoutConstraint.activate([
            lbTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 2.0*margin),
            lbTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2.0*margin),
            lbTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0*margin),
            lbTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2.0*margin),
            ])
    }
    
    func addGestureForSubviews() {
        
    }
}

