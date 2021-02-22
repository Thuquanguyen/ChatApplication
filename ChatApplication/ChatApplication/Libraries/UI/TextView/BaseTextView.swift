//
//  BaseTextView.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

class BaseTextView: UITextView {
    
    // MARK: - Outlets
    @IBInspectable var maxCharCount: Int = 0
    @IBInspectable var isStyleDefault: Bool = true
    @IBInspectable var borderColorDefault: UIColor = #colorLiteral(red: 0.6352941176, green: 0.737254902, blue: 0.737254902, alpha: 1)
    @IBInspectable var borderColorFocus: UIColor = #colorLiteral(red: 0.2509803922, green: 0.8862745098, blue: 0.7647058824, alpha: 1)
    @IBInspectable var borderColorWarning: UIColor = #colorLiteral(red: 1, green: 0.4509803922, blue: 0.5568627451, alpha: 1)
    @IBInspectable var textHint: String? = nil
    
    // MARK: - Typealias
    typealias TextDidChangeResponse = ((_ newText: String) -> Void)
    typealias TextStateResponse = (() -> Void)
    typealias ContentSizeDidChangeResponse = ((_ size: CGSize) -> Void)
    
    // MARK: - Variables
    fileprivate weak var textHintLabel: UILabel?
    fileprivate var maxBytes: Int?
    
    // MARK: - Closures
    var textDidChangeHandler: TextDidChangeResponse?
    fileprivate var didBeginEditingHandler: TextStateResponse?
    fileprivate var didEndEditingHandler: TextStateResponse?
    fileprivate var didChangeContentSizeHandler: ContentSizeDidChangeResponse?
    
    // MARK: - Override functions
    override var contentSize: CGSize {
        didSet {
            didChangeContentSizeHandler?(contentSize)
        }
    }
    
    override var text: String! {
        didSet {
            refreshPlaceholder()
        }
    }
    
    var isWarning: Bool = false {
        didSet {
            setBorderColor = isWarning ? borderColorWarning : borderColorDefault
        }
    }
    
    // MARK: - Draw functions
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
        setupStyleDefault()
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addTextHintLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addTextHintLabel()
    }
    
    func setupStyleDefault() {
        if !isStyleDefault { return }
        roundCorners(radius: 6)
        setBorderWidth = 1
        setBorderColor = borderColorDefault
    }
    
    // MARK: - Setup functions
    private func setupTextView() {
        delegate = self
        clipsToBounds = true
    }
    
    private func addTextHintLabel() {
        if textHintLabel?.superview == nil {
            let label = UILabel()
            label.font = UIFont.regular(size: 16)
            label.textColor = #colorLiteral(red: 0.6352941176, green: 0.737254902, blue: 0.737254902, alpha: 1)
            label.textAlignment = .left
            label.numberOfLines = 0
            label.isUserInteractionEnabled = false
            addSubview(label)
            textHintLabel = label
            let constraints: [NSLayoutConstraint] = [
                AutoLayoutHelper.equalConstraint(label, superView: self, attribute: .top, constant: 7),
                AutoLayoutHelper.equalConstraint(label, superView: self, attribute: .left, constant: 5),
            ]
            label.translatesAutoresizingMaskIntoConstraints = false
            addConstraints(constraints)
        }
        textHintLabel?.text = textHint
    }
    
    // MARK: - Builder
    @discardableResult
    func set(placeHolder: String) -> BaseTextView {
        textHintLabel?.text = placeHolder
        layoutIfNeeded()
        setNeedsDisplay()
        return self
    }
    
    @discardableResult
    func set(text: String) -> BaseTextView {
        self.text = text
        textViewDidChange(self)
        return self
    }
    
    @discardableResult
    func maxCharacters(count: Int) -> BaseTextView {
        maxCharCount = count
        return self
    }
    
    @discardableResult
    func maxBytes(count: Int) -> BaseTextView {
        maxBytes = count
        return self
    }
    
    @discardableResult
    func textDidChange(handler: @escaping TextDidChangeResponse) -> BaseTextView {
        textDidChangeHandler = handler
        return self
    }
    
    @discardableResult
    func didBeginEditing(handler: @escaping TextStateResponse) -> BaseTextView {
        didBeginEditingHandler = handler
        return self
    }
    
    @discardableResult
    func didEndEditing(handler: @escaping TextStateResponse) -> BaseTextView {
        didEndEditingHandler = handler
        return self
    }
    
    @discardableResult
    func didChangeContentSize(handler: @escaping ContentSizeDidChangeResponse) -> BaseTextView {
        didChangeContentSizeHandler = handler
        return self
    }
    
    func refreshPlaceholder() {
        togglePlaceholderLabelBy(text: self.text)
    }

    // MARK: - Update UI
    fileprivate func togglePlaceholderLabelBy(text: String) {
        guard let label = textHintLabel else { return }
        let isHidden = text != ""
        label.isHidden = isHidden
        if !isHidden { bringSubviewToFront(label) }
    }
}

extension BaseTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Check to show or hide placeholder label
        togglePlaceholderLabelBy(text: textView.text)
        textDidChangeHandler?(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if maxCharCount > 0 {
            if newText.count > maxCharCount {
                textView.text = String(newText.prefix(maxCharCount))
                return false
            } else {
                return newText.count <= maxCharCount
            }
        } else if let maxBytes = maxBytes, let currentBytes = newText.getBytesBy(encoding: SystemUtils.shiftJISEncoding) {
            return currentBytes <= maxBytes
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isStyleDefault {
            setBorderColor = borderColorFocus
        }
        didBeginEditingHandler?()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        text = textView.text.trimWhiteSpacesAndNewLines
        if isStyleDefault {
            setBorderColor = borderColorDefault
        }
        didEndEditingHandler?()
    }
}
