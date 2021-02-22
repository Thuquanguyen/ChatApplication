//
//  WhiteNavigationView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/16/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class WhiteNavigationView: UIView {
    
    // MARK: - Properties
    lazy var buttonBack: UIButton = {
        let v = UIButton(type: .custom)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage.init(named: "Icon"), for: .normal)
        v.contentHorizontalAlignment = .left
        return v
    }()
    
    lazy var lbTitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 1
        v.font = Constants.font.lato(type: .bold, size: 16.0)
        v.textColor = Constants.color.appDefaultText
        v.textAlignment = .center
//        v.adjustsFontSizeToFitWidth = true
        return v
    }()
    
    lazy var separateView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Constants.color.lightSeperator
        return v
    }()
    
    // MARK: Right Button
    lazy var rightView: DefaultFilterEntryButtonView = {
        let v = DefaultFilterEntryButtonView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.icon = nil
        return v
    }()
    
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }
    
    var imageRightIcon: UIImage? {
        didSet {
            rightView.icon = imageRightIcon
        }
    }
    
    // MARK: - Delegates
    weak var delegate: NavigationActionable?
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
        imageRightIcon = nil
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    
}


extension WhiteNavigationView: SubviewsLayoutable {
    func addSubviews() {
        
        addSubview(buttonBack)
        addSubview(lbTitle)
        addSubview(separateView)
        
        addSubview(rightView)
    }
    
    func setupAutolayoutForSubviews() {
        NSLayoutConstraint.activate([
            buttonBack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
            buttonBack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            buttonBack.widthAnchor.constraint(equalToConstant: 35),
            buttonBack.heightAnchor.constraint(equalToConstant: 50),
            
            lbTitle.leftAnchor.constraint(equalTo: buttonBack.rightAnchor, constant: 0),
            lbTitle.centerYAnchor.constraint(equalTo: buttonBack.centerYAnchor),
            lbTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            separateView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            separateView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            separateView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
            separateView.heightAnchor.constraint(equalToConstant: 0.3),
            
            rightView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
            rightView.centerYAnchor.constraint(equalTo: lbTitle.centerYAnchor),
            rightView.widthAnchor.constraint(equalToConstant: 36.0),
            rightView.heightAnchor.constraint(equalTo: rightView.widthAnchor, multiplier: 1.0)
            ])
    }
    
    func addGestureForSubviews() {
        buttonBack.addSingleTapGesture(target: self, selector: #selector(pressBack))
        rightView.addSingleTapGesture(target: self, selector: #selector(pressRightAction))
    }
}


//MARK: ACTION
extension WhiteNavigationView {
    @objc func pressBack() {
        if let delegate = self.delegate {
            delegate.didPressLeftButton()
        } else {
            VCService.pop()
        }
    }
    
    @objc func pressRightAction() {
        delegate?.didPressRightButton?()
    }
}
