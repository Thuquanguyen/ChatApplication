//
//  InsetTextField.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//
import UIKit

class InsetTextField: UITextField {

    // MARK: - Inspectable
    @IBInspectable var insetTop: CGFloat = 0
    @IBInspectable var insetLeft: CGFloat = 10
    @IBInspectable var insetBottom: CGFloat = 0
    @IBInspectable var insetRight: CGFloat = 10
    
    @IBInspectable var icon: UIImage? = nil
    @IBInspectable var iconSize: CGFloat = 12
    
    @IBInspectable var isStyleDefault: Bool = true
    @IBInspectable var borderColorDefault: UIColor = #colorLiteral(red: 0.6352941176, green: 0.737254902, blue: 0.737254902, alpha: 1)
    @IBInspectable var borderColorFocus: UIColor = #colorLiteral(red: 0.2509803922, green: 0.8862745098, blue: 0.7647058824, alpha: 1)
    @IBInspectable var borderColorWarning: UIColor = #colorLiteral(red: 1, green: 0.4509803922, blue: 0.5568627451, alpha: 1)

    @IBInspectable var isShowLeftIcon: Bool = false
    @IBInspectable var leftIcon: UIImage? = nil
    @IBInspectable var maxLength: Int = 0
    @IBInspectable var decimal: Int = 1
    
    var removeText : (()-> Void)?

    override var placeholder: String? {
        didSet {
            if let str = placeholder {
                attributedPlaceholder = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6352941176, green: 0.737254902, blue: 0.737254902, alpha: 1)])
            }
        }
    }
    
    override var keyboardType: UIKeyboardType {
        didSet {
            
        }
    }
    
    var textChanged: ((_ text: String?) -> Void)? {
        didSet {
            removeTarget(self, action: #selector(textChangedAction), for: .editingChanged)
            addTarget(self, action: #selector(textChangedAction), for: .editingChanged)
        }
    }
    
    private var insets: UIEdgeInsets {
        return UIEdgeInsets(top: insetTop, left: insetLeft, bottom: insetBottom, right: insetRight)
    }
    
    var didTap: (() -> Void)? = nil {
        didSet {
            addButton()
            button?.didTap = self.didTap
        }
    }
    
    var delayTextChanged: Double? = nil // time second
    private var mTimer: Timer?
    private var button: ImageButton?
    var leftImageView: UIImageView?{
        didSet {
            leftImageView?.addSingleTapGesture(target: self, selector: #selector(removeTextField))
        }
    }

    @objc func removeTextField(){
        removeText?()
    }
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        delegate = self
        setupStyleDefault()
    }
    
    func setupStyleDefault() {
        if !isStyleDefault { return }
        borderStyle = .none
        roundCorners(radius: 6)
        setBorderWidth = 1
        setBorderColor = borderColorDefault
        font = UIFont.regular(size: 14)
        textColor = #colorLiteral(red: 0.1137254902, green: 0.1764705882, blue: 0.2862745098, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if icon != nil {
            addButton()
        }
        setupLeftIcon()
    }
    
    func addButton() {
        if button == nil {
            let btn = ImageButton()
            button = btn
            resignFirstResponder()
            btn.sizeIcon = iconSize
            btn.align = .right
            btn.iconMarginRight = 10
            btn.iconImage = icon
            addSubview(btn)
            btn.translatesAutoresizingMaskIntoConstraints = false
            AutoLayoutHelper.fit(btn, superView: self)
        }
    }
    
    func setupLeftIcon() {
        if isShowLeftIcon {
            if leftImageView != nil {
                return
            }
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: height))
            let imageView = UIImageView()
            leftImageView = imageView
            let size = CGSize(width: 16, height: 16)
            imageView.frame.size = size
            imageView.frame.origin = CGPoint(x: (view.width - size.width) / 2, y: (view.height - size.height) / 2)
            imageView.contentMode = .scaleAspectFit
            imageView.image = leftIcon ?? UIImage(named: "icon_search")
            imageView.tintColor = #colorLiteral(red: 0.4352941176, green: 0.8274509804, blue: 0.8352941176, alpha: 1)
            leftViewMode = .always
            view.addSubview(imageView)
            leftView = view
            if semanticContentAttribute == .forceRightToLeft {
                insetRight = view.width
            } else {
                insetLeft = view.width
            }
        } else {
            leftViewMode = .never
            leftView = nil
        }
    }
    
    var isWarning: Bool = false {
        didSet {
            setBorderColor = isWarning ? borderColorWarning : borderColorDefault
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    @objc func textChangedAction() {
        
        if let delay = delayTextChanged {
            mTimer?.invalidate()
            mTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: {[weak self] _ in
                self?.textChanged?(self?.text)
            })
        } else {
            textChanged?(text)
        }
        print("\(text)")
    }
}

extension InsetTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let setOf =  CharacterSet(charactersIn: string)
        switch keyboardType {
        case .decimalPad:
            let allowCharacter = CharacterSet(charactersIn: ".0123456789")
            if !allowCharacter.isSuperset(of: setOf) {
                return false
            }
        case .numberPad:
            let allowCharacter = CharacterSet(charactersIn: "0123456789")
            if !allowCharacter.isSuperset(of: setOf) {
                return false
            }
        case .phonePad:
            let allowCharacter = CharacterSet(charactersIn: "+0123456789")
            if !allowCharacter.isSuperset(of: setOf) {
                return false
            }
        case .alphabet:
            if !CharacterSet.letters.isSuperset(of: setOf) && !CharacterSet.whitespaces.isSuperset(of: setOf) {
                return false
            }
        default:
            break
        }
        guard let str = textField.text, let newText = (str as NSString?)?.replacingCharacters(in: range, with: string) else {
            return true
        }
        if maxLength > 0 {
            if keyboardType == .decimalPad {
                if str.contains(".") {
                    if string == "." { return false }
                    let array = newText.components(separatedBy: ".")
                    if array.count == 2 {
                        return array[1].count <= 1 && newText.count <= maxLength + 1 + decimal
                    } else {
                        return newText.count <= maxLength
                    }
                } else {
                    if string == "." {
                        return newText.count <= maxLength + 1 + decimal
                    }
                    return newText.count <= maxLength
                }
            }
            return newText.count <= maxLength
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isStyleDefault {
            setBorderColor = borderColorFocus
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isStyleDefault {
            setBorderColor = borderColorDefault
        }
        text = textField.text?.trimWhiteSpacesAndNewLines
    }
}

enum InputType {
    case numeric,
    alphabet,
    alphanumeric,
    email,
    phone,
    none
}
