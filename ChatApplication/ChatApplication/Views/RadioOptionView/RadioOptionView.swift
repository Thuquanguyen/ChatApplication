//
//  RadioOptionView.swift
//  AIC Utilities People
//
//  Created by TiemLV on 6/11/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class RadioOptionView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak private var radioImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    
    // MARK: - Closures
    var didSelectedRadio: ((Int) -> Void)?
    
    // MARK: - Properties
    var isSelected: Bool = false {
        didSet {
            radioImageView.image = isSelected ? UIImage() : UIImage()
        }
    }
    
    // MARK: - View's life cycles
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
        isSelected = false
        self.isUserInteractionEnabled = true
        self.addSingleTapGesture(target: self, selector: #selector(selectedItemHandle))
    }
    
    @objc
    private func selectedItemHandle() {
        didSelectedRadio?(self.tag)
    }
    
    func bindingData(isSelected: Bool = false, name: String? = nil) {
        self.isSelected = isSelected
        self.nameLabel.text = name
    }
    
}

extension RadioOptionView {
    
    private func commonInit() {
        guard let view = UINib(nibName: "RadioOptionView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
}
