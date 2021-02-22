//
//  FlexibleButton.swift
//  TetViet
//
//  Created by vinhdd on 12/19/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit

@IBDesignable class FlexibleButton: UIButton {
    
    // MARK: - IBInspectables
    @IBInspectable var numberOfLines: Int = 1 { didSet { titleLabel?.numberOfLines = numberOfLines } }
    @IBInspectable var exclusiveTouchEnabled: Bool = false { didSet { isExclusiveTouch = exclusiveTouchEnabled } }
    @IBInspectable var titleBelowImage: Bool = false
    @IBInspectable var titleOnLeftImage: Bool = false
    @IBInspectable var titleFixToBottom: Bool = false
    @IBInspectable var titleVerticalAlign: CGFloat = 0.0
    @IBInspectable var titleToImageDistance: CGFloat = 0.0
    @IBInspectable var imageToRightBoundDistance: CGFloat = 0.0
    @IBInspectable var fixedTitleBottom: CGFloat = 0.0
    
    // MARK: - Closures
    var didTap: (() -> Void)?

    // MARK: - Life cycles
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        isExclusiveTouch = exclusiveTouchEnabled
        clipsToBounds = false
        layer.masksToBounds = false
        titleLabel?.textAlignment = .center
        addTarget(self, action: #selector(touchUpInsideButtonAction(sender:)), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc private func touchUpInsideButtonAction(sender: UIButton) {
        didTap?()
    }
    
    // MARK: - Update UI
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Title & image position
        if titleBelowImage {
            alignTextBelowImage(spacing: 20,
                                fixedTitleBottom: 10,
                                verticalAlign: titleVerticalAlign)
        } else if titleOnLeftImage {
            if titleToImageDistance != 0.0 {
                alignImageToRightOfText(fixedRightOfTextSpace: titleToImageDistance,
                                        verticalAlign: titleVerticalAlign)
            } else {
                alignImageToRightOfText(fixedRightBoundSpace: imageToRightBoundDistance,
                                        verticalAlign: titleVerticalAlign)
            }
        }
    }
}

