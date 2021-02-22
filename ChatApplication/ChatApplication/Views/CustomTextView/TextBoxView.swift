//
//  TextBoxView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/16/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

@objc protocol TextboxViewDelegate: AnyObject {
    func didUpdateTextBox(text: String?, tag: Int)
    @objc optional func didTapTextBox(tag: Int)
}

class TextboxView: UIView {
    
    // MARK: - Properties
    @IBInspectable var placeholder: String? = "" {
        didSet {
            setPlaceholder()
        }
    }
    
    lazy var textView: UITextView = {
        let v = UITextView()
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
    
    var isBeginEditing: Bool = false
    
    var textString: String? {
        didSet {
            updateText(text: textString)
        }
    }
    var textViewTag: Int? {
        didSet {
            textView.tag = textViewTag ?? -1
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
            textView.keyboardType = keyboardType ?? UIKeyboardType.default
        }
    }
    
    var isTriggerTapGesture: Bool?
    
    var textLimitedCount = Constants.limitCharacterContent
    var isPastedText = false
    var isOnlyAllowNumber = false
    
    // MARK: - Delegates
    weak var delegate: TextboxViewDelegate?
    
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


extension TextboxView: SubviewsLayoutable {
    func addSubviews() {
        self.setCorner(5.0)
        self.set(borderWidth: 1.0, withColor: Constants.color.lightSeperator)
        
        addSubview(textView)
        setPlaceholder()
    }
    
    func setupAutolayoutForSubviews() {
        heightTextBoxConstraint = self.heightAnchor.constraint(equalToConstant: heightTextBoxview)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0),
            heightTextBoxConstraint!
            ])
        heightTextBoxConstraint?.priority = UILayoutPriority(rawValue: 999.0)
    }
    
    func addGestureForSubviews() {
        
    }
}


//MARK: CONFIG
extension TextboxView {
    func setPlaceholder() {
        textView.text = placeholder
        textView.textColor = Constants.color.placeholder
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
    func updatePlaceholderText() {
        textView.text = placeholder
    }
    
    func updateText(text: String?) {
        if text?.isEmpty == true || text == nil {
            return
        }
        textView.text = text
        textView.textColor = Constants.color.appDefaultText
    }
    
    func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty, textView.textColor != Constants.color.placeholder else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        
        return true
    }
}


//MARK: UTILITIES
extension TextboxView {
    func updateHeightTextBox() {
        heightTextBoxConstraint?.constant = heightTextBoxview
    }
    
    func limitText(fullText: String) {
        self.textView.text = String(fullText.prefix(textLimitedCount)) // drop text behind index textLimitedCount (255)
        self.isPastedText = true
    }
}


extension TextboxView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isTriggerTapGesture == true {
            textView.resignFirstResponder()
            delegate?.didTapTextBox?(tag: textView.tag)
            return false
        }
        isBeginEditing = true
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        isBeginEditing = false
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if validate(textView: textView) {
            // self.enableSendButton(isEnable: true)
        } else {
            // self.enableSendButton(isEnable: false)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        let newLength = updatedText.count

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            self.setPlaceholder()
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == Constants.color.placeholder && !text.isEmpty {
            textView.textColor = Constants.color.appDefaultText
            
            if newLength > textLimitedCount, text.contains(UIPasteboard.general.string ?? "") {
                if isOnlyAllowNumber == true {
                    if !text.isValidPhone {
                        self.setPlaceholder()
                        return false
                    }
                }
                self.limitText(fullText: text)
            } else {
                textView.text = text
            }
        }
            
            // For every other case, the text should change with the usual behavior
        else {
            if newLength > textLimitedCount, text.contains(UIPasteboard.general.string ?? "") {
                if isOnlyAllowNumber == true {
                    if !text.isValidPhone {
                        self.setPlaceholder()
                        return false
                    }
                }
                self.limitText(fullText: updatedText)
            } else {
                return newLength <= textLimitedCount
            }
        }
        
        // ...otherwise return false since the updates have already been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let text = textView.text
        if isBeginEditing == true {
            if text == placeholder {
                self.delegate?.didUpdateTextBox(text: "", tag: textView.tag)
            } else {
                self.delegate?.didUpdateTextBox(text: text, tag: textView.tag)
            }
        }
        
        if self.window != nil {
            if textView.textColor == Constants.color.placeholder {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            } else {
                DispatchQueue.main.async {
                    if self.isPastedText {
                        let end = self.textView.endOfDocument
                        let range = self.textView.textRange(from: end, to: end)
                        self.textView.selectedTextRange = range
                        
                        self.isPastedText = false
                    }
                }
            }
        }
    }
}

