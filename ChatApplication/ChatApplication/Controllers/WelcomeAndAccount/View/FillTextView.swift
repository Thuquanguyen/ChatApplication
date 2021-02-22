//
//  fillTextView.swift
//  YTeThongMinh
//
//  Created by QuanNH on 5/27/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

@objc
protocol FillTextViewDelegate: class {
    @objc optional func textFieldDidChange(_ text: String?)
}

class FillTextView: BaseCustomView {
    
    // MARK: - Outlets
    @IBOutlet weak var textField: PasswordTextField!
    @IBOutlet weak var viewBoundButtonRight: UIView!
    @IBOutlet weak var imageLeft: UIImageView!
    @IBOutlet weak var imageRight: UIImageView!
    
    // MARK: - Delegate
    weak var delegate: FillTextViewDelegate?
    
    // MARK: - Properties
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var isSecureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureTextEntry
            imageRight.image = isSecureTextEntry ? UIImage("login_eye") : UIImage("login_eye-1")
        }
    }
    var isShowIconHide = false
    var maxLength = 30
    
    private let font = UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.setPlaceholder(font: font, textColor: UIColor(r: 162, g: 188, b: 188))
    }
    
    func set(_ iconLeft: String, _ placeHolder: String?, _ isShowRight: Bool = false, isRequired: Bool = false, isSecret: Bool = false, max: Int) {
        isShowIconHide = isShowRight
        imageLeft.image = UIImage(iconLeft)
        textField.placeholder = placeHolder
        isSecureTextEntry = isSecret
        maxLength = max
        
        if isRequired {
            let attributed = NSMutableAttributedString(string: placeHolder ?? "", attributes: [
              .font: UIFont(name: "Roboto-Regular", size: 14.0)!,
              .foregroundColor: UIColor(red: 162.0 / 255.0, green: 188.0 / 255.0, blue: 188.0 / 255.0, alpha: 1.0)
            ])
            let attributedRequired = NSAttributedString(string: "*", attributes: [NSAttributedString.Key.font: font , NSAttributedString.Key.foregroundColor : UIColor(red: 1.0, green: 115.0 / 255.0, blue: 142.0 / 255.0, alpha: 1.0)])
            attributed.append(attributedRequired)
            textField.attributedPlaceholder = attributed
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonShowPassword(_ sender: Any) {
        isSecureTextEntry = !isSecureTextEntry
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        let text = sender.text?.prefix(maxLength) ?? ""
        sender.text = String(text)
        if isShowIconHide {
            viewBoundButtonRight.isHidden = sender.text?.count == 0
        }
        delegate?.textFieldDidChange?(sender.text)
    }
}

class PasswordTextField: UITextField {

    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }

    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }

}
