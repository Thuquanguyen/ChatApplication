//
//  DefaultFilterEntryButtonView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/6/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class DefaultFilterEntryButtonView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var lbCount: UILabel!
    
    // MARK: - Properties
    var icon: UIImage? {
        didSet {
            imgIcon.image = icon
        }
    }
    
    var count: Int = 0 {
        didSet {
            if count > 0 {
                lbCount.text = "\(count)"
                countView.isHidden = false
            } else {
                countView.isHidden = true
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "DefaultFilterEntryButtonView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        
        count = 0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        countView.setCorner(countView.bounds.width/2.0)
    }
}
