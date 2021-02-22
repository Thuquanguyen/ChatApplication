//
//  CustomTextView.swift
//  AIC Utilities People
//
//  Created by IchNV-D1 on 5/11/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit
protocol CustomTextViewDelegate: class {
    func textViewDidEndEditing()
}
class CustomTextView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var txtContent: UITextView!
    
    // MARK: - Delegates
    weak var delegate: CustomTextViewDelegate?
    
    // MARK: - Properties
    var text = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    var PLACEHOLDER_TEXT = "Nội dung phản ánh" {
        didSet {
            txtContent.text = PLACEHOLDER_TEXT
        }
    }
    let PLACEHOLDER_COLOR: UIColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    let DEFAULT_COLOR: UIColor = #colorLiteral(red: 0.2980392157, green: 0.3137254902, blue: 0.3294117647, alpha: 1)
    
    internal var textContent: String {
        return txtContent.text == PLACEHOLDER_TEXT ? "" : txtContent.text
    }
    private func commonInit() {
        guard let view = UINib(nibName: "CustomTextView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        self.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtContent.delegate = self
        txtContent.text = PLACEHOLDER_TEXT
        txtContent.textColor = PLACEHOLDER_COLOR
    }
    
    func moveCursorToStart(aTextView: UITextView){
        DispatchQueue.main.async {
            aTextView.selectedRange = NSMakeRange(0, 0)
        }
    }
}

extension CustomTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == PLACEHOLDER_COLOR {
            moveCursorToStart(aTextView: textView)
            textView.textColor = PLACEHOLDER_COLOR
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && textView.text == PLACEHOLDER_TEXT{
            textView.text = PLACEHOLDER_TEXT
            textView.textColor = PLACEHOLDER_COLOR
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 {
            if textView.text == PLACEHOLDER_TEXT{
                textView.text = ""
                textView.textColor = DEFAULT_COLOR
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != PLACEHOLDER_TEXT {
            text = textView.text
        }
    }
    
}
