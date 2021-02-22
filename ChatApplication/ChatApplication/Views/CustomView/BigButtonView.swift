//
//  BigButtonView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/16/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol BigButtonViewDelegate: AnyObject {
    func didPressBigButton()
}

class BigButtonView: UIView {

    // MARK: - Properties
    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Constants.color.appHighlightButton
        v.setCorner(10.0)
        return v
    }()
    
    lazy var lbTitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 1
        v.font = Constants.font.lato(type: .bold, size: Constants.DefaultValues.FontSize.largeButtonTitle)
        v.textColor = Constants.color.appWhiteText
        v.adjustsFontSizeToFitWidth = true
        v.text = ""
        v.textAlignment = .center
        return v
    }()
    
    lazy var separateView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Constants.color.lightSeperator
        return v
    }()
    
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }
    
    // MARK: - Delegates
    weak var delegate: BigButtonViewDelegate?
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension BigButtonView: SubviewsLayoutable {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(lbTitle)
        addSubview(separateView)
    }
    
    func setupAutolayoutForSubviews() {
        let margin: CGFloat = Constants.DefaultValues.Size.margin
        let buttonHeight: CGFloat = Constants.DefaultValues.Size.buttonHeight
        
        NSLayoutConstraint.activate([
            separateView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            separateView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            separateView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
            separateView.heightAnchor.constraint(equalToConstant: 0.5),
            
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3.0*margin),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3.0*margin),
            containerView.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            lbTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            lbTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0),
            lbTitle.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0),
            lbTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0),
            
            ])
    }
    
    func addGestureForSubviews() {
        containerView.addSingleTapGesture(target: self, selector: #selector(pressRecruitButton))
    }
}

extension BigButtonView {
    @objc func pressRecruitButton() {
        delegate?.didPressBigButton()
    }
}

