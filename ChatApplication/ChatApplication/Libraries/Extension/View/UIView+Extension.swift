//
//  UIView+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
import WebKit
import Toast_Swift

protocol XibView {
    static var name: String { get }
    static func createFromXib() -> Self
}

extension XibView where Self: UIView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func createFromXib() -> Self {
        return Self.init()
    }
    
    func rotate(duration: CFTimeInterval = 0.8, toValue: Any = Float.pi*2, repeatCount: Float = Float.infinity, removeOnCompleted: Bool = false) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = duration
        animation.toValue = toValue
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = removeOnCompleted
        layer.add(animation, forKey: "rotate")
    }
}

extension UIView: XibView { }

extension UIView {
    @IBInspectable var viewCornerRadius: CGFloat {
        set {
            setCorner(newValue)
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var setBorderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var setBorderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

// MARK: - Extension for all
extension UIView {
    // MARK: - Variables
    var name: String {
        return type(of: self).name
    }
        
    var height: CGFloat {
        return self.frame.size.height
    }
    
    var width: CGFloat {
        return self.frame.size.width
    }
    
    var subviewsRecursive: [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive }
    }
    
    // specific type of view
    func getSpecifiedTypeInSubviews<T: UIView>() -> [T] {
        var subviews = [T]()
        self.subviews.forEach { subview in
            subviews += subview.getSpecifiedTypeInSubviews() as [T]
            if let subview = subview as? T {
                subviews.append(subview)
            }
        }
        return subviews
    }
    
    var parentViewController: UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.parentViewController
        } else {
            return nil
        }
    }
    
    var globalPointWithEntireScreen: CGPoint? {
        return superview?.convert(frame.origin, to: nil)
    }
    
    var globalFrameWithEntireScreen: CGRect? {
        return superview?.convert(frame, to: nil)
    }

    // MARK: - Local functions
    func set(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
    
    func setCorner(radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    func set(borderWidth: CGFloat, withColor color: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
    
    func set(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        set(cornerRadius: cornerRadius)
        set(borderWidth: borderWidth, withColor: borderColor)
    }
    
    func setShadow( c color: UIColor, oW offSetW: CGFloat, oH offSetH: CGFloat, r radius: CGFloat, o opacity: CGFloat = 1) {
        let offSet = CGSize(width: offSetW, height: offSetH)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = Float(opacity)
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
    func addShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    /**
    Make simple set alpha color replace opacity
    */
    func setShadowSimple(c color: UIColor, ow offSetWidth: CGFloat, oh offSetHeight: CGFloat, r radius: CGFloat, opacity: Float = 1) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: offSetWidth, height: offSetHeight)
        layer.shadowRadius = radius
    }
    
    /* Duypx */
    func setShadowOrange(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat) {
//        clipsToBounds = false
//        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
    func setShadow(color: UIColor, offSet: CGSize, opacity: Float = 0.5, radius: CGFloat = 1, scale: Bool = true) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func setShadowDefault() {
        layer.cornerRadius = 6
        layer.shadowOpacity = 0.45
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    func setShadowAroundView(radius: CGFloat = 2.0) {
        self.addShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1.0, height: 1.0), radius: radius)
    }
    
    func setShadowHighlightAroundView() {
        self.addShadow(color: .darkGray, opacity: 0.4, offSet: CGSize(width: 1.0, height: 1.0), radius: 2.0)
    }
    
    /* Duypx */
    func setShadowOrangeAroundView(radius: CGFloat = 8) {
        self.setShadowOrange(color: UIColor(red:1, green:0.84, blue:0.77, alpha:1), opacity: 1, offSet: CGSize(width: 0, height: 2), radius: radius)
    }
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor, gradientDirection: GradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = gradientDirection.draw().x
        gradientLayer.endPoint = gradientDirection.draw().y
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundRectWith(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func setCorner(_ radius: CGFloat, isborder: Bool = false) {
        self.layer.cornerRadius = radius
        if isborder {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            self.layer.borderWidth = 0.0
            self.layer.borderColor = UIColor.clear.cgColor
        }
        self.layer.masksToBounds = true
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

// Extension for cutting & masking layers
extension UIView {
    func cut(rect: CGRect) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(bounds)
        p.addRect(rect)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = s
    }
    
    func cut(path: CGPath) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(bounds)
        p.addPath(path)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        layer.mask = s
    }
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}

// Extension for autolayout
extension UIView {
    static let maxPriority: UILayoutPriority = UILayoutPriority(999)
    static let minPriority: UILayoutPriority = UILayoutPriority(1)
    
    @discardableResult
    func centerTo(superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            getEqualConstraintTo(superView: superView, attribute: .centerX),
            getEqualConstraintTo(superView: superView, attribute: .centerY)
        ]
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func fitTo(superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            getEqualConstraintTo(superView: superView, attribute: .top),
            getEqualConstraintTo(superView: superView, attribute: .left),
            getEqualConstraintTo(superView: superView, attribute: .right),
            getEqualConstraintTo(superView: superView, attribute: .bottom)
        ]
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func sameSizeTo(superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            getEqualConstraintTo(superView: superView, attribute: .width),
            getEqualConstraintTo(superView: superView, attribute: .height)
        ]
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func sameWidthTo(superView: UIView) -> NSLayoutConstraint {
        let constraint = getEqualConstraintTo(superView:superView, attribute: .width)
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func sameHeightTo(superView: UIView) -> NSLayoutConstraint {
        let constraint = getEqualConstraintTo(superView:superView, attribute: .height)
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func setRatioWith(multiplier: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = getRatioConstraintWith(multiplier: multiplier)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    func getEqualConstraintTo(superView: UIView,
                              attribute: NSLayoutConstraint.Attribute,
                              constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: superView,
                                            attribute: attribute,
                                            multiplier: 1,
                                            constant: constant)
        return constraint
    }
    
    func getFixedConstraintWith(attribute: NSLayoutConstraint.Attribute,
                                value: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: value)
        return constraint
    }
    
    func getRelatedConstraintTo(superView: UIView,
                                attribute: NSLayoutConstraint.Attribute,
                                relatedBy: NSLayoutConstraint.Relation,
                                constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: relatedBy,
                                            toItem: superView,
                                            attribute: attribute,
                                            multiplier: 1,
                                            constant: constant)
        return constraint
    }
    
    func getRatioConstraintWith(multiplier: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .width,
                                            multiplier: multiplier,
                                            constant: 0)
        return constraint
    }
    
    func showCustomToast(icon: UIImage? = "sorryPigIcon".image,
                         title: String = "",
                         message: String,
                         duration: TimeInterval = 1.0,
                         position: ToastPosition = .center,
                         alpha: CGFloat = 0.6,
                         completion: (() -> Void)? = nil) {
        // calculate width
        let widthView = SystemInfo.screenWidth * 2/3
        let widthLabel = widthView - 20 * 2
        
        // calculate height
        let messageHeight = message.height(withWidth: widthLabel, font: UIFont.regular(size: 16))
        let titleHeight: CGFloat = title.isEmpty ? 0 : 20
        let otherHeight: CGFloat = 17 + 44 + 11 + 16 + 10
        let heightView: CGFloat = titleHeight + messageHeight + otherHeight
        
        // create vieư
        //show
    
    }
    
    // loading and toast
    final func showToast(_ message: String) {
        self.makeToast(message, duration: 1, position: .center)
    }
    
    final func showToast(_ message: String , position : ToastPosition) {
        self.makeToast(message, duration: 1, position: position)
    }
    
}

//TODO: Animation

extension UIView {
    
    //Hide a view with default animation
    
    func hide(animation: Bool = true, duration: TimeInterval = 0.3, completion: (() -> ())? = nil) {
        
        //allway update UI on mainthread
        DispatchQueue.main.async {
            
            if !animation || self.isHidden {
                self.isHidden = true
                completion?()
                return
            }
            
            let currentAlpha = self.alpha
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0
            }, completion: { (success) in
                self.isHidden = true
                self.alpha = currentAlpha
                completion?()
            })
        }
    }
    
    //Show a view with animation
    
    func show(animation: Bool = true, duration: TimeInterval = 0.3, completion: (() -> ())? = nil) {
        
        //allway update UI on mainthread
        DispatchQueue.main.async {
            
            if !animation || !self.isHidden {
                self.isHidden = false
                completion?()
                return
            }
            
            let currentAlpha = self.alpha
            self.alpha = 0.05
            self.isHidden = false
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = currentAlpha
            }, completion: { (success) in
                completion?()
            })
        }
    }
    
    //rotate view 3D with Z
    
    func rotate(duration: CFTimeInterval = 0.7, toValue: Any = -Float.pi*2, repeatCount: Float = Float.infinity, removeOnCompleted: Bool = false) {
        if layer.animation(forKey: "rotate") != nil {
            return
        }
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = toValue
        animation.repeatCount = repeatCount
        animation.isCumulative = true
        animation.isRemovedOnCompletion = removeOnCompleted
        layer.add(animation, forKey: "rotate")
    }
    
    // Remove rotate animation
    func stopRotate() {
        if layer.animation(forKey: "rotate") != nil {
            layer.removeAnimation(forKey: "rotate")
        }
    }
    
    
    //MARK: - AddConstraint with Visual Format Language
    func addConstraintWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                      options: NSLayoutConstraint.FormatOptions(),
                                                      metrics: nil, views: viewsDictionary))
    }
    
    func setHide(hidden: Bool, duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.alpha = hidden ? 0 : 1
        })
    }
    
}
extension UIView {
    
    func fitParent(padding: UIEdgeInsets = .zero) {
        
        guard let parent = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: padding.top),
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: padding.left),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: padding.bottom),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: parent, attribute: .right, multiplier: 1, constant: padding.right)
            ])
    }
    
    /// animation touch up inside View
    /// - Parameters:
    ///   - view: view want effect
    ///   - level: allway set default
    func animationClickView(_ view: UIView, level: Int = 0) {
        for (_, subview) in view.subviews.enumerated() {
            if String(describing: type(of: subview)) == "UILabel" {
                guard let label = subview as? UILabel else { return }
                UIView.animate(withDuration: 0.4) {
                    label.alpha = 0.5
                    label.alpha = 1
                }
            }
            
            if String(describing: type(of: subview)) == "UIImageView" {
                guard let imageView = subview as? UIImageView else { return }
                UIView.animate(withDuration: 0.4) {
                    imageView.alpha = 0.5
                    imageView.alpha = 1
                }
            }
            
            if String(describing: type(of: subview)) == "UIView" {
                UIView.animate(withDuration: 0.4) {
                    subview.alpha = 0.5
                    subview.alpha = 1
                }
            }
            animationClickView(subview, level: level + 1)
        }
    }
    
}

//TODO: Instance Nib

extension UIView {
    
    class func nib() -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed( name, owner: nil, options: nil)![0] as! T
    }
    
}


extension UIView {
    //MARK: Add Gesture Recognizer
    func addSingleTapGesture(target: Any?, selector: Selector) -> Void {
        let tap = UITapGestureRecognizer(target: target, action: selector)
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
}

extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }
        
        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }
        
        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }
        
        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        path.closeSubpath()
        cgPath = path
    }
}

extension UIView{
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0, borderColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0 ) {
        self.layoutIfNeeded()
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        let borderLayer = CAShapeLayer()
        borderLayer.path = (self.layer.mask! as! CAShapeLayer).path! // Reuse the Bezier path
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
//
//    func roundCorners(corners: CACornerMask, radius: CGFloat) {
//        self.layer.cornerRadius = radius
//        self.clipsToBounds = true
//        if #available(iOS 11.0, *) {
//            self.layer.maskedCorners = corners
//        } else {
//            roundCorners(corners: [.topLeft, .topRight], radius: radius)
//        }
//    }
    
    func roundCorners(_ corners: UIRectCorner = [.allCorners], radius: CGFloat) {
        if #available(iOS 11.0, *) {
            var maskedCorners: CACornerMask = []
            if corners.contains(.topLeft) {
                maskedCorners.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.bottomLeft) {
                maskedCorners.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.topRight) {
                maskedCorners.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.bottomRight) {
                maskedCorners.insert(.layerMaxXMaxYCorner)
            }
            layer.cornerRadius = radius
            clipsToBounds = true
            layer.maskedCorners = maskedCorners
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = frame
            rectShape.position = center
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
            layer.mask = rectShape
        }
    }
}

extension UIView {
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [1, 3]
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func drawDashedLine(startPoint: CGPoint, endPoint: CGPoint, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 2]
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    func constraintToAllSides(of container: UIView, topOffset: CGFloat = 0, leadingOffset: CGFloat = 0, bottomOffset: CGFloat = 0, trailingOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor, constant: topOffset),
            leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: leadingOffset),
            bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: bottomOffset),
            trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: trailingOffset)
            ])
    }
}

// Add Webview into specific subview
extension UIView {
    func addWebviewInside() -> WKWebView {
        let v = WKWebView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        self.addSubview(v)
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: self.topAnchor),
            v.leftAnchor.constraint(equalTo: self.leftAnchor),
            v.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            v.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
        return v
    }
}

// Add coneradius
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
