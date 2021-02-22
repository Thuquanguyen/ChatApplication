//
//  ImageButton.swift
//  Develop
//
//  Created by DatTV-d1 on 2/28/20.
//  Copyright © 2020 RikkeiSoft. All rights reserved.
//


import UIKit

//@IBDesignable
open class ImageButton: UIButton {
    
    // MARK: - IBInspectable

//    @IBInspectable open var textColor: UIColor?

    @IBInspectable open var textColorHighlighted: UIColor?
    
    @IBInspectable var iconMarginLeft: CGFloat = 3
    @IBInspectable var iconMarginRight: CGFloat = 3
    @IBInspectable var textMarginRight: CGFloat = 3
    @IBInspectable var textMarginLeft: CGFloat = 3

    @IBInspectable var sizeIcon: CGFloat = 24.0

    // iconAlign : right or left
    @IBInspectable open var iconAlign: String = "right" {
        didSet {
            align = AlignIcon(rawValue: self.iconAlign) ?? AlignIcon.right
        }
    }
    
    // textAlign : right or left
    @IBInspectable open var textAlign: String?
    
    @IBInspectable open var imageColor: UIColor? {
        didSet {
            setupIconImageView()
        }
    }
    
    @IBInspectable open var iconImage: UIImage? {
        didSet {
            setupIconImageView()
        }
    }

    // MARK: - Variable
    
    var didTap: (() -> Void)? = nil {
        didSet {
            removeTarget(self, action: #selector(actionClicked(sender:)), for: .touchUpInside)
            if self.didTap != nil {
                addTarget(self, action: #selector(actionClicked(sender:)), for: .touchUpInside)
            }
        }
    }
    
    var align: AlignIcon = .right {
        didSet {
            self.updateIconConstraint()
        }
    }
    
    var text: String? {
        set (value) {
            setTitle(value, for: .normal)
        }
        get {
            return title(for: .normal)
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                alpha = 1
            } else {
                alpha = 0.4
            }
        }
    }
    
    private let duration: Double = 0.4
    var iconImageView: UIImageView?
    private var iconConstraints = [NSLayoutConstraint]()
    private var bgColor: UIColor = .clear

    private var mTimer: Timer?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        bgColor = backgroundColor ?? .clear
    }

    // MARK: - Life cycle
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.lineBreakMode = .byTruncatingTail
//        setTitleColor(textColor ?? UIColor.blue, for: .normal)
        setTitleColor(textColorHighlighted ?? titleColor(for: .highlighted), for: [.selected, .highlighted])
        updateIconConstraint()
    }
    
//    open override var intrinsicContentSize: CGSize {
//        var mSize = super.intrinsicContentSize
//        if self.iconImage != nil {
//            let delta = sizeIcon + iconMarginRight + iconMarginLeft + textMarginLeft + textMarginRight
//            if mSize.width + delta >= self.frame.width  {
//                mSize.width = self.frame.width + delta
//            }
//        }
//        return mSize
//    }
//
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        parentViewController?.view.endEditing(true)
        if isUserInteractionEnabled {
            self.setAlphaSubViews(1)
            UIView.animate(withDuration: duration, animations: {
                self.setAlphaSubViews(0.5)
                //                    self.backgroundColor = UIColor.init(hex: 0xf1f1f1).alpha(0.6)
            })
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if isUserInteractionEnabled {
            UIView.animate(withDuration: duration, animations: {
                self.setAlphaSubViews(1)
                //            self.backgroundColor = self.bgColor
            })
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
         if isUserInteractionEnabled {
            UIView.animate(withDuration: duration, animations: {
                self.setAlphaSubViews(1)
                //            self.backgroundColor = self.bgColor
            })
        }
    }
    
    func setAlphaSubViews(_ alpha: CGFloat) {
        self.iconImageView?.alpha = alpha
        self.titleLabel?.alpha = alpha
    }
    
    private func updateIconConstraint() {
    
        if let icon = iconImageView {
            removeConstraints(iconConstraints)
            iconConstraints.removeAll()
            iconConstraints += [NSLayoutConstraint(item: icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: sizeIcon),
             NSLayoutConstraint(item: icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: sizeIcon)]
            let insets: UIEdgeInsets
            if align == .center {
                iconConstraints += [NSLayoutConstraint(item: icon, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)]
                insets = UIEdgeInsets(top: 0, left: textMarginLeft, bottom: 0, right: (frame.width / 2 + sizeIcon / 2 + iconMarginRight))
                contentHorizontalAlignment = .left
            }else if align == .right {
                iconConstraints += [NSLayoutConstraint(item: icon, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -iconMarginRight)]
                insets = UIEdgeInsets(top: 0, left: textMarginLeft, bottom: 0, right: sizeIcon + iconMarginRight + iconMarginLeft)
                contentHorizontalAlignment = .right
            } else {
                iconConstraints += [NSLayoutConstraint(item: icon, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: iconMarginLeft)]
                contentHorizontalAlignment = .left
                insets = UIEdgeInsets(top: 0, left: sizeIcon + iconMarginRight + iconMarginLeft, bottom: 0, right: textMarginRight)
            }
            titleEdgeInsets = insets
            iconConstraints += [NSLayoutConstraint(item: icon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)]
            addConstraints(iconConstraints)
        }

        if self.textAlign == "right" {
            contentHorizontalAlignment = .right
            if iconImageView != nil {
                titleEdgeInsets = UIEdgeInsets(top: 0, left: sizeIcon + iconMarginRight + iconMarginLeft, bottom: 0, right: textMarginRight)
            }
        } else if self.textAlign == "left" {
            contentHorizontalAlignment = .left
            if iconImageView != nil {
                titleEdgeInsets = UIEdgeInsets(top: 0, left: textMarginLeft, bottom: 0, right: sizeIcon + iconMarginRight + iconMarginLeft)
            }
        }
    }

    private func setupIconImageView() {
        if iconImageView == nil {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            addSubview(imageView)
            iconImageView = imageView
            updateIconConstraint()
        }
        if let color = self.imageColor {
            iconImageView?.image = iconImage?.filledImage(fillColor: color)
        } else {
            iconImageView?.image = iconImage
        }
    }

    enum AlignIcon: String {
        case left,
        right,
        center
    }
    
    @objc private func actionClicked(sender: UIButton) {
        didTap?()
    }
    
    func setStyleImage(mode: ContentMode = .scaleAspectFit, corner: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        iconImageView?.contentMode = mode
        iconImageView?.roundCorners(radius: corner)
        iconImageView?.setBorderWidth = borderWidth
        iconImageView?.setBorderColor = borderColor
    }
}
