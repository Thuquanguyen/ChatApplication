//
//  LargeTitleHeaderView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/14/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class LargeTitleHeaderView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var titleLeadingCs: NSLayoutConstraint!
    @IBOutlet weak var titleTrailingCs: NSLayoutConstraint!
    @IBOutlet weak var titleBottomCs: NSLayoutConstraint!
    @IBOutlet weak var titleTopCs: NSLayoutConstraint!
    
    // MARK: - Properties
    var title: String? {
        didSet {
            lbTitle.text = title
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
    
    func updateTitleConstraint(topOffset: CGFloat, leadingOffset: CGFloat, trailingOffset: CGFloat, bottomOffset: CGFloat) {
        titleLeadingCs.constant = leadingOffset
        titleTrailingCs.constant = trailingOffset
        titleTopCs.constant = topOffset
        titleBottomCs.constant = bottomOffset
        layoutIfNeeded()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "LargeTitleHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.backgroundColor = .white
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    
    }
}


//MARK: ANIMATION
extension LargeTitleHeaderView {
    func animateTitle(alpha: CGFloat, ratio: CGFloat = 0.7) {
        var alp = alpha
        if alp < 1 - ratio {
            alp = 0
        }
        lbTitle.alpha = alp
    }
}

