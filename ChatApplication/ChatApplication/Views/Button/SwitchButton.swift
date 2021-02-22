//
//  SwitchButton.swift
//  YTeThongMinh
//
//  Created by ThanhND on 7/4/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

protocol SwitchButtonDelegate: class {
    func didTapSwitch(isON: Bool)
}

@IBDesignable
class SwitchButton: UIView {
    
    private var elipticalView: UIView!
    private var thumb: UIView!
    private var thumbTrailingConstraint: NSLayoutConstraint!
    
    weak var delegate: SwitchButtonDelegate?
    @IBInspectable var onThumbColor: UIColor = UIColor.white
    @IBInspectable var offThumbColor: UIColor = UIColor.white
    @IBInspectable var onBackgroundColor: UIColor = UIColor.green
    @IBInspectable var offBackgroungColor: UIColor = UIColor.gray
    @IBInspectable var padding: CGFloat = 2
    @IBInspectable var isOn: Bool = false
    
    private var isSwitching: Bool = false
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setState()
    }
    
    private func commonInit() {
        elipticalView = UIView()
        elipticalView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(elipticalView)
        elipticalView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding).isActive = true
        elipticalView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -padding).isActive = true
        elipticalView.topAnchor.constraint(equalTo: topAnchor, constant: -padding).isActive = true
        elipticalView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding).isActive = true
        elipticalView.layer.cornerRadius = (frame.size.height + padding*2)/2
        
        thumb = UIView()
        thumb.translatesAutoresizingMaskIntoConstraints = false
        addSubview(thumb)
        thumbTrailingConstraint = thumb.trailingAnchor.constraint(equalTo: trailingAnchor)
        thumbTrailingConstraint.isActive = true
        thumb.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
        thumb.widthAnchor.constraint(equalToConstant: frame.size.height).isActive = true
        thumb.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        thumb.layer.cornerRadius = frame.size.height/2
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        button.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
        button.addTarget(self, action: #selector(didTapOnThumb), for: .touchUpInside)
        
//        thumb.addSingleTapGesture(target: self, selector: #selector(didTapOnThumb))
        
    }
    @objc private func didTapOnThumb() {
        if !isSwitching {
            isOn = !isOn
            setState(duration: 0.2)
            delegate?.didTapSwitch(isON: isOn)
        }
    }
    
    /**
     It gives nice animation to thumb when switched ON or OFF.
     Changes the color.
     */
    private func setState(duration: TimeInterval = 0.0) {
        if !isSwitching {
            isSwitching = true
            if isOn {
                UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.thumbTrailingConstraint.constant = 0
                    self.layoutIfNeeded()
                }, completion: { success in
                    self.isSwitching = false
                })
                elipticalView.backgroundColor = onBackgroundColor
                thumb.backgroundColor = onThumbColor
            } else {
                UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.thumbTrailingConstraint.constant = -(self.frame.size.width - self.thumb.frame.width)
                    self.layoutIfNeeded()
                }, completion: { success in
                    self.isSwitching = false
                })
                elipticalView.backgroundColor = offBackgroungColor
                thumb.backgroundColor = offThumbColor
            }
        }
    }
}
