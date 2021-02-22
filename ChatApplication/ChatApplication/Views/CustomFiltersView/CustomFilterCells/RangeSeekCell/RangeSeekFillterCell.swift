//
//  RangeSeekFillterCell.swift
//  AIC Utilities People
//
//  Created by IchNV-D1 on 8/5/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol RangeSeekFillterDelegate: AnyObject {
    func didSelectRangeSeek(minValue: Float, maxValue: Float)
}

class RangeSeekFillterCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var lbTitle: UILabel!
    
    // MARK: - Properties
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }
    
    // MARK: - Closures
    var resultOptionChange: ((CGFloat,CGFloat) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDataRangeSlider(minValue: CGFloat, maxValue: CGFloat, title: String?, selectedMinValue: CGFloat?, selectedMaxValue: CGFloat?) {
        self.title = title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
