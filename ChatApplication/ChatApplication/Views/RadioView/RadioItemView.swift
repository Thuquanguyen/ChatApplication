//
//  RadioView.swift
//  AIC Utilities People
//
//  Created by toannt on 5/6/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class RadioItem {
    var state = false
    var title = ""
    
    init(state: Bool, title: String) {
        self.state = state
        self.title = title
    }
}

class RadioItemView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    // MARK: - Properties
    var radioItem: RadioItem! {
        didSet {
            setData(item: radioItem)
        }
    }
    
    var mode: RadioCellMode = .choose
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "RadioItemView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        backgroundColor = .clear
    }
    
    private func setData(item: RadioItem) {
        setState(isActive: item.state)
        lblName.text = item.title
    }
    
    func setState(isActive: Bool) {
        let selectedImage = mode == .choose ? UIImage() : #imageLiteral(resourceName: "check_on.png")
        let unSelectImage = mode == .choose ? UIImage() : #imageLiteral(resourceName: "check_off.png")
        imgState.image = isActive ? selectedImage : unSelectImage
    }
}

