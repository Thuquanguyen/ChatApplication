//
//  CheckBoxGender.swift
//  TetViet
//
//  Created by KienPT on 1/16/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CheckBoxGender: UIButton {
    
    // MARK: - Inspectable
    @IBInspectable var checkedImage : UIImage?
    @IBInspectable var uncheckedImage : UIImage?
    @IBInspectable var isChecked: Bool = false {
        didSet {
            let image = isChecked ? checkedImage : uncheckedImage
            setBackgroundImage(image, for: .normal)
            isChecked ? setBordSelected() : setRemoveSelected()
        }
    }
    
    // MARK: - Closure
    var didCheck: ((_ isChecked: Bool) -> Void)?
    
    private func setBordSelected() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderColor = UIColor("EE4848").cgColor
        self.layer.borderWidth = 2
        self.layer.masksToBounds = true
    }
    
    
    private func setRemoveSelected() {
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.layer.masksToBounds = true
    }
    
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        isChecked = false
    }
    
    // MARK: - Action
    @objc private func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            didCheck?(isChecked)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
