//
//  CheckBox.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

@IBDesignable class CheckBox: ImageButton {
    
    // MARK: - Inspectable
    @IBInspectable var checkedImage : UIImage? = #imageLiteral(resourceName: "ic_checked.pdf")
    @IBInspectable var uncheckedImage : UIImage? = #imageLiteral(resourceName: "ic_unchecked.pdf")
    @IBInspectable var isChecked: Bool = false {
        didSet {
            iconImage = isChecked ? checkedImage : uncheckedImage
        }
    }
    
    // MARK: - Closure
    var didCheck: ((_ isChecked: Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
     
    }
    
    // MARK: - Setup
    override func setup() {
        super.setup()
        align = .center
        isChecked = false
        removeTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpOutside)
        addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
    }
    
    // MARK: - Action
    @objc private func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            didCheck?(isChecked)
        }
    }
}
