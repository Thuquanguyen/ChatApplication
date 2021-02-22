//
//  DropDownCustomView.swift
//  AIC Utilities People
//
//  Created by TiemLV on 6/12/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class DropDownCustomView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak private var titleTextField: UITextField!
    
    // MARK: - Closures
    var didTouchUpInsideView: ((_ tag: Int?) -> Void)?
    
    // MARK: - Properties
    var placeholder: String? {
        didSet {
            titleTextField.placeholder = placeholder
        }
    }
    
    var text: String? {
        didSet {
            titleTextField.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        titleTextField.isUserInteractionEnabled = false
        titleTextField.set(rightPadding: 20)
        layoutIfNeeded()
        self.addSingleTapGesture(target: self, selector: #selector(touchUpInsideView))
    }
    
    @objc
    private func touchUpInsideView() {
        didTouchUpInsideView?(self.tag)
    }
    
}

extension DropDownCustomView {
    
    private func commonInit() {
        guard let view = UINib(nibName: "DropDownCustomView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
}
