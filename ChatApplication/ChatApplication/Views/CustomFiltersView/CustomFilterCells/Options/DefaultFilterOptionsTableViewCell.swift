//
//  DefaultFilterOptionsTableViewCell.swift
//  AIC Utilities People
//
//  Created by TiemLV on 6/5/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class DefaultFilterOptionsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionLeftView: UIView!
    @IBOutlet weak var optionRightView: UIView!
    @IBOutlet weak var optionLeftLabel: UILabel!
    @IBOutlet weak var optionRightLabel: UILabel!
    @IBOutlet weak var optionLeftImage: UIImageView!
    @IBOutlet weak var optionRightImage: UIImageView!
    
    // MARK: - Properties
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isLeftSelected: Bool? {
        didSet {
            setOptionSelected(isLeftSelected)
        }
    }
    
    // MARK: - Closures
    var resultOptionChange: ((Int) -> Void)?
    
    func bindingData(_ model: [FilterDetailCellModeling], index: Int? = nil) {
        if model.isEmpty { return }
        optionLeftLabel.text = model[0].title
        optionRightLabel.text = model[1].title
        
        if let indexItem = index {
            self.isLeftSelected = indexItem == 0
        } else {
            isLeftSelected = nil
            setOptionSelected(nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionLeftImage.image = UIImage()
        optionRightImage.image = UIImage()
        optionLeftView.addSingleTapGesture(target: self, selector: #selector(handleLeftAction))
        optionRightView.addSingleTapGesture(target: self, selector: #selector(handleRightAction))
    }
    
    @objc func handleLeftAction() {
        isLeftSelected = true
        resultOptionChange?(0)
    }
    
    @objc func handleRightAction() {
        isLeftSelected = false
        resultOptionChange?(1)
    }
    
    func setOptionSelected(_ isLeftSelected: Bool?) {
        guard let isLeftSelected = isLeftSelected else {
            optionLeftImage.image = UIImage()
            optionRightImage.image = UIImage()
            return
        }
        
        optionLeftImage.image = isLeftSelected ? UIImage() : UIImage()
        optionRightImage.image = isLeftSelected ? UIImage() : UIImage()
        
    }
    
}
