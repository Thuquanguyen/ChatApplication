//
//  DefaultFilterFourOptionsCell.swift
//  AIC Utilities People
//
//  Created by TiemLV on 6/11/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class DefaultFilterFourOptionsCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var radioOptionView: [RadioOptionView]!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Closures
    var resultOptionChange: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bindingData(_ model: [FilterDetailCellModeling], index: Int? = nil) {
        
        radioOptionView.enumerated().forEach { (offset, radioView) in
            
            let isSelected = offset == index
            
            radioView.tag = offset
            radioView.bindingData(isSelected: isSelected, name: model[offset].title)
            radioView.didSelectedRadio = { [weak self] tag in
                self?.updateRadioSelected(tag: tag)
            }
        }
        
    }
    
    private func updateRadioSelected(tag: Int) {
        
        radioOptionView.enumerated().forEach { (offset, radio) in
            
            if radio.tag == tag {
                radio.isSelected = true
                resultOptionChange?(offset)
            } else {
                radio.isSelected = false
            }
        }
    }
    
}
