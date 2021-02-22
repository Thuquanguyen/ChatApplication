//
//  TabbarContentView.swift
//  XKLD
//
//  Created by PhucND-GD on 2/24/20.
//  Copyright © 2020 vinhdd. All rights reserved.
//

import UIKit


class TabbarContentView: ESTabBarItemContentView {

    public var duration = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .white
        titleFont = Constants.font.lato(type: .bold, size: 12)
        highlightTextColor = .white
        iconColor = .white
        highlightIconColor = .white
        imageView.contentMode = .scaleAspectFit
        //renderingMode = .alwaysOriginal
        backdropColor = UIColor.init("#F86E84")
        highlightBackdropColor = UIColor.init("#F86E84")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }

    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
    

}

