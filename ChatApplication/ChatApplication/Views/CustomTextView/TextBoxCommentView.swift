//
//  TextBoxCommentView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/16/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol TextBoxCommentViewDelegate: AnyObject {
    func didUpdateTextBox(text: String?, tag: Int)
    func didPressSendButton(text: String?)
    func didUpdateHeightTextView()
}

class TextBoxCommentView: UIView {

    // MARK: - Closures
    var didAccessTyping: (() -> Void)?
    
    // MARK: - Properties
    lazy var textView: UITextView = {
        let v = UITextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.clear
        v.font = Constants.font.lato(type: .regular, size: 17.0)
        //        v.borderWidth = 0.5
        //        v.borderColor = UIColor.gray.withAlphaComponent(0.5)
        //        v.cornerRadius = 5.0
        v.delegate = self
        return v
    }()
    
    lazy var boundView: UIView = {
        let bound = UIView()
        bound.translatesAutoresizingMaskIntoConstraints = false
        bound.backgroundColor = UIColor.clear
        return bound
    }()
    
    lazy var sendView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        //        v.backgroundColor = .green
        return v
    }()
    
    lazy var imgSend: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.image = UIImage()
        //        v.backgroundColor = .blue
        return v
    }()
    
    weak var delegate: TextBoxCommentViewDelegate?
    var isBeginEditing: Bool = false
    var previousRect = CGRect.zero

    var textString: String? {
        didSet {
            updateText(text: textString)
        }
    }
    
    var placeholder: String? {
        didSet {
            setPlaceholder()
        }
    }
    
    var textViewTag: Int? {
        didSet {
            textView.tag = textViewTag ?? -1
        }
    }
    
    var heightTextBoxCommentView: CGFloat = 50.0 {
        didSet {
            updateHeightTextBox()
        }
    }
    var heightTextBoxConstraint : NSLayoutConstraint?
    
    var textLimitedCount = Constants.limitCharacterComment
    var isPastedText = false

    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAutolayoutForSubviews()
        checkHiddenBoundView()
        addGestureForSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TextBoxCommentView: SubviewsLayoutable {
    func addSubviews() {
        self.setCorner(5.0)
        self.set(borderWidth: 1.0, withColor: Constants.color.lightSeperator)
        
        addSubview(textView)
        addSubview(sendView)
        sendView.addSubview(imgSend)
        addSubview(boundView)
        setPlaceholder()
    }
    
    func setupAutolayoutForSubviews() {
        heightTextBoxConstraint = self.heightAnchor.constraint(equalToConstant: heightTextBoxCommentView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            textView.rightAnchor.constraint(equalTo: sendView.leftAnchor, constant: -8.0),
            heightTextBoxConstraint!,
            
            boundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            boundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            boundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            boundView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            
            sendView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),
            sendView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0.0),
            sendView.widthAnchor.constraint(equalToConstant: 40.0),
            sendView.heightAnchor.constraint(equalTo: sendView.widthAnchor, multiplier: 1.0),
            
            imgSend.bottomAnchor.constraint(equalTo: sendView.bottomAnchor, constant: -5.0),
            imgSend.widthAnchor.constraint(equalToConstant: 20.0),
            imgSend.heightAnchor.constraint(equalTo: imgSend.widthAnchor, multiplier: 1.0),
            imgSend.centerXAnchor.constraint(equalTo: sendView.centerXAnchor),
            
            ])
        heightTextBoxConstraint?.priority = UILayoutPriority(rawValue: 999.0)
    }
    
    func checkHiddenBoundView() {
        if let _ = SharedData.accessToken {
            boundView.removeFromSuperview()
        }
    }
    
    func addGestureForSubviews() {
        sendView.addSingleTapGesture(target: self, selector: #selector(pressSendButton))
        boundView.addSingleTapGesture(target: self, selector: #selector(tapTextView))
    }
}


//MARK: CONFIG
extension TextBoxCommentView {
    func setPlaceholder() {
        textView.text = placeholder
        textView.textColor = Constants.color.placeholder
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        
        //        self.enableSendButton(isEnable: false)
//        textView.textContainer.maximumNumberOfLines = 1
//        textView.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    func updatePlaceholderText() {
        textView.text = placeholder
        //        textView.textColor = Constants.color.placeholder
    }
    
    func updateText(text: String?) {
        if text?.isEmpty == true || text == nil {
            removeText()
            return
        }
        textView.text = text
        textView.textColor = UIColor.black
    }
    
    func removeText() {
        setPlaceholder()
        self.delegate?.didUpdateTextBox(text: "", tag: textView.tag)
        sendView.isUserInteractionEnabled = false
        imgSend.image = UIImage()
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
extension TextBoxCommentView {
    func updateHeightTextBox() {
        heightTextBoxConstraint?.constant = heightTextBoxCommentView
    }
    
    func limitText(fullText: String) {
        self.textView.text = String(fullText.prefix(textLimitedCount)) // drop text behind index textLimitedCount (255)
        
        self.isPastedText = true
    }
}


extension TextBoxCommentView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        isBeginEditing = true
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        isBeginEditing = false
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if validate(textView: textView) {
            //self.enableSendButton(isEnable: true)
        } else {
            //self.enableSendButton(isEnable: false)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
//        textView.textContainer.maximumNumberOfLines = 0

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
                self.limitText(fullText: text)
            } else {
                textView.text = text
            }
        }
            
            // For every other case, the text should change with the usual behavior
        else {
            if newLength > textLimitedCount, text.contains(UIPasteboard.general.string ?? "") {
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
            if text == placeholder || text?.isEmpty ?? true {
                self.delegate?.didUpdateTextBox(text: "", tag: textView.tag)
                sendView.isUserInteractionEnabled = false
                imgSend.image = UIImage()
            } else {
                self.delegate?.didUpdateTextBox(text: text, tag: textView.tag)
                sendView.isUserInteractionEnabled = true
                imgSend.image = UIImage()
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
        
        //Update height textview
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        self.previousRect = self.previousRect.origin.y == 0.0 ? currentRect : previousRect
        
        let subHight = currentRect.origin.y - previousRect.origin.y
        if subHight > 0 {
            //new line reached, write your code
            heightTextBoxCommentView += subHight
            if heightTextBoxCommentView > 150.0 {
                heightTextBoxCommentView = 150.0
            }
            delegate?.didUpdateHeightTextView()
        } else if subHight < 0 {
            if currentRect.origin.y < 150 {
                heightTextBoxCommentView += subHight
            }
            if heightTextBoxCommentView < 50.0 {
                heightTextBoxCommentView = 50.0
            }
            delegate?.didUpdateHeightTextView()
        }
        
        previousRect = currentRect
    }
}


extension TextBoxCommentView {
    @objc func pressSendButton() {
        delegate?.didPressSendButton(text: textView.text)
    }
    
    @objc func tapTextView() {
        
    }
}
