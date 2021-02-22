//
//  NewsNavigationView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/10/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class NewsNavigationView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var btnButtonLeft: UIButton!
    @IBOutlet weak var leftButtonView: UIView!
    @IBOutlet weak var rightButtonView: UIView!
    @IBOutlet weak var imgButtonRight: UIImageView!
    @IBOutlet weak var lbLeft: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var right2ButtonView: UIView!
    @IBOutlet weak var imgButtonRight2: UIImageView!
    
    // MARK: - Delegates
    weak var delegate: NavigationActionable?
    
    // MARK: - Properties
    var leftTitle: String? {
        didSet {
            lbLeft.text = leftTitle
        }
    }
    
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }
    
    var rightIcon: UIImage? {
        didSet {
            imgButtonRight.image = rightIcon
        }
    }
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "NewsNavigationView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
}


extension NewsNavigationView: SubviewsLayoutable {
    func addSubviews() {
    
    }
    
    func setupAutolayoutForSubviews() {
       
    }
    
    func addGestureForSubviews() {
        leftButtonView.addSingleTapGesture(target: self, selector: #selector(pressBack))
        lbLeft.addSingleTapGesture(target: self, selector: #selector(pressBack))
        rightButtonView.addSingleTapGesture(target: self, selector: #selector(pressRightAction))
        right2ButtonView.addSingleTapGesture(target: self, selector: #selector(pressRight2Action))
    }
}


//MARK: ACTION
extension NewsNavigationView {
    @objc func pressBack() {
        delegate?.didPressLeftButton()
    }
    
    @objc func pressRightAction() {
        delegate?.didPressRightButton?()
    }
    
    @objc func pressRight2Action() {
        delegate?.didPressRight2Button?()
    }
}


extension NewsNavigationView {
    func animateNavigation(alpha: CGFloat) {
        let beta = 1 - alpha
        
        self.lbTitle.alpha = beta
        self.lbLeft.alpha = alpha
        self.backgroundColor = UIColor.white.alpha(beta)
        self.btnButtonLeft.imageView?.set(color: beta > 0.3 ? UIColor.black.alpha(beta) : UIColor.white)
    }
}
