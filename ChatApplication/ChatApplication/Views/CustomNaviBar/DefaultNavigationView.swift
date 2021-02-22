//
//  DefaultNavigationView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/14/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

@objc protocol NavigationActionable: AnyObject {
    func didPressLeftButton()
    @objc optional func didPressRightButton()
    @objc optional func didPressRight2Button()
    @objc optional func didTapCenterView()
}

class DefaultNavigationView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var leftButtonView: UIView!
    @IBOutlet weak var rightButtonView: UIView!
    @IBOutlet weak var imgButtonRight: UIImageView!
    @IBOutlet weak var lbLeft: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnButtonBack: UIButton!
    @IBOutlet weak var separateView: UIView!
    @IBOutlet weak var heightNaviConstraint: NSLayoutConstraint!
    
    // MARK: - Delegates
    weak var delegate: NavigationActionable?
    
    // MARK: - Closures
    var didPressRightButton: (() -> ())?
    
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
    
    var imageBack: UIImage = UIImage() {
        didSet {
            btnButtonBack.setImage(imageBack, for: .normal)
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
        guard let view = UINib(nibName: "DefaultNavigationView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
        heightNaviConstraint.constant = Constants.DefaultValues.Size.naviHeight + SystemInfo.statusBarHeight
    }
    
    // MARK: - Actions
    @IBAction func eventClickBack(_ sender: Any) {
        self.pressBack()
    }
    
    func showBottomSeparateView() {
        separateView.isHidden = false
    }
}


extension DefaultNavigationView: SubviewsLayoutable {
    func addSubviews() {
        animateCenterTitle(alpha: 0.0)
    }
    
    func setupAutolayoutForSubviews() {
        
    }
    
    func addGestureForSubviews() {
        lbLeft.addSingleTapGesture(target: self, selector: #selector(pressBack))
        rightButtonView.addSingleTapGesture(target: self, selector: #selector(pressRightAction))
    }
}


//MARK: ACTION
extension DefaultNavigationView {
    @objc func pressBack() {
        if let delegate = self.delegate {
            delegate.didPressLeftButton()
        } else {
            VCService.pop()
        }
    }
    
    @objc func pressRightAction() {
        if let delegate = self.delegate {
            delegate.didPressRightButton?()
        } else {
            didPressRightButton?()
        }
    }
}


//MARK: ANIMATION
extension DefaultNavigationView {
    func animateCenterTitle(alpha: CGFloat, ratio: CGFloat = 0.7) {
        var alp = alpha
        
        if alpha > ratio {
            alp = 1.0
        }
        if alpha < ratio {
            alp = 0.0
        }
        let beta = 1 - alp
        
        lbTitle.alpha = alp
        lbLeft.alpha = beta
    }
    
    func animateTitle(contentOffsetY: CGFloat, heightHeader: CGFloat, alphaHeader: ((_ alpha: CGFloat) -> Void)? = nil) {
        var alpha = contentOffsetY/heightHeader
        
        if alpha > 0.7 {
            alpha = 1.0
        }
        if alpha < 0.6 {
            alpha = 0.0
        }
        animateCenterTitle(alpha: alpha)
        alphaHeader?(1 - alpha)
    }
    
    func animateTitle(progress: CGFloat, alphaHeader: ((_ alpha: CGFloat) -> Void)? = nil) {
        var alpha = progress
        if alpha > 0.7 {
            alpha = 1
        }
        if alpha < 0.6 {
            alpha = 0
        }
        
        let beta = 1 - alpha
        
        lbLeft.alpha = alpha
        lbTitle.alpha = beta
        alphaHeader?(alpha)
    }
    
    func animateBackground(alpha: CGFloat) {        
        backgroundColor = UIColor.white.alpha(alpha)
    }
}
