//
//  TextFieldBoxView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/27/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class TextFieldBoxView: UIView {

    // MARK: - Properties
    lazy var textField: UITextField = {
        let v = UITextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.clear
        v.font = Constants.font.lato(type: .regular, size: 16.0)
        v.textColor = Constants.color.appDefaultText
        //        v.borderWidth = 0.5
        //        v.borderColor = UIColor.gray.withAlphaComponent(0.5)
        //        v.cornerRadius = 5.0
        v.delegate = self
        return v
    }()
    
    
    var textString: String? {
        didSet {
            textField.text = textString
        }
    }
    
    @IBInspectable var placeholder: String? = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    var textFieldTag: Int? {
        didSet {
            textField.tag = textFieldTag ?? -1
        }
    }
    
    var heightTextBoxview: CGFloat = 50.0 {
        didSet {
            updateHeightTextBox()
        }
    }
    var heightTextBoxConstraint : NSLayoutConstraint?
    
    var keyboardType: UIKeyboardType? {
        didSet {
            textField.keyboardType = keyboardType ?? UIKeyboardType.default
        }
    }
    
    var textLimitedCount = Constants.limitCharacterSearch
    
    // MARK: - Delegates
    weak var delegate: TextboxViewDelegate?

    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubviews()
        self.setupAutolayoutForSubviews()
        self.addGestureForSubviews()
    }
    
}


extension TextFieldBoxView: SubviewsLayoutable {
    func addSubviews() {
        self.setCorner(5.0)
        self.set(borderWidth: 1.0, withColor: Constants.color.lightSeperator)
        
        addSubview(textField)
    }
    
    func setupAutolayoutForSubviews() {
        heightTextBoxConstraint = self.heightAnchor.constraint(equalToConstant: heightTextBoxview)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0),
            heightTextBoxConstraint!
            ])
        heightTextBoxConstraint?.priority = UILayoutPriority(rawValue: 999.0)
    }
    
    func addGestureForSubviews() {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}


//MARK: CONFIG
extension TextFieldBoxView {
    func validate(textField: UITextField) -> Bool {
        guard let text = textField.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty, textField.textColor != UIColor.lightGray else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        
        return true
    }
}


//MARK: UTILITIES
extension TextFieldBoxView {
    func updateHeightTextBox() {
        heightTextBoxConstraint?.constant = heightTextBoxview
    }
}


extension TextFieldBoxView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if newLength > textLimitedCount, string.contains(UIPasteboard.general.string ?? "") {
            let fullText = text + string
            textField.text = String(fullText.prefix(textLimitedCount)) // drop text behind index textLimitedCount (255)

            DispatchQueue.main.async {
                let end = self.textField.endOfDocument
                let range = self.textField.textRange(from: end, to: end)
                self.textField.selectedTextRange = range
            }
            
            delegate?.didUpdateTextBox(text: textField.text, tag: textField.tag)

            return false
        }
        
        return newLength <= textLimitedCount
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.didUpdateTextBox(text: textField.text, tag: textField.tag)
    }
}
