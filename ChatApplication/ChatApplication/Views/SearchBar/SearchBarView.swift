
//
//  SearchBarView.swift
//  Develop
//
//  Created by quannh on 4/2/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

@objc
protocol SearchBarViewDelegate {
    @objc optional func textFieldBegin(text: String)
    @objc optional func textFieldEnd(text: String)
    @objc optional func textFieldDidChange(text: String)
    @objc optional func didClickButton(type: SearchBarView.TypeButtonClick)
    @objc optional func textFieldShouldReturn(text: String)
    @objc optional func clearTextField()
}

class SearchBarView: UIView,UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var viewDeleteText: UIView!
    @IBOutlet weak var viewDeleteTextHeight: NSLayoutConstraint!
    @IBOutlet var constraintWidthClear: NSLayoutConstraint!
    @IBOutlet var constraintLeadingBar: NSLayoutConstraint!
    @IBOutlet var viewBoundSearch: UIView!
    @IBOutlet var textFieldSearch: UITextField!
    @IBOutlet var imageIconSearch: UIImageView!
    @IBOutlet var imageIconRight: UIImageView!
    
    // MARK: - Properties
    var timer : Timer?
    
    @objc
    enum TypeButtonClick: Int {
        case search
        case clear
        case speak
    }
    
    @IBInspectable var isHaveClearButton: Bool = false {
        didSet {
            constraintWidthClear.constant = isHaveClearButton ? bounds.size.height : 0
        }
    }
    
    var placeholder: String? {
        didSet {
            textFieldSearch.placeholder = placeholder
        }
    }
    
    var isSpeak = false {
        didSet{
            if let image = imageIconRight {
                if isSpeak {
                    image.image = UIImage(named: "chat_bot_mic_btn")
                } else {
                    image.image = UIImage(named: "closeSearchIcon")
                }
            }
        }
    }
    var animationBar = false {
        didSet{
            self.searchBarExpand()
        }
    }
    var isExpand = true
    var duration = 0.4
    
    // MARK: - Delegates
    weak var delegate: SearchBarViewDelegate?

    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "SearchBarView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        
        self.backgroundColor = .white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setClearButtonVisible(isVisible: false)
        setTextSearchView()
    }
    
    private func setTextSearchView() {
        imageIconSearch.set(color: UIColor(displayP3Red: 0.2, green: 0.23, blue: 0.26, alpha: 1))
        viewBoundSearch.backgroundColor = UIColor(displayP3Red: 0.86, green: 0.86, blue: 0.86, alpha: 0.5)
        textFieldSearch.delegate = self
        textFieldSearch.textColor = UIColor(displayP3Red: 0.23, green: 0.27, blue: 0.3, alpha: 1)
        textFieldSearch.setPlaceholder(font: Constants.font.lato(type: .regular, size: 16), textColor: UIColor(displayP3Red: 0.64, green: 0.65, blue: 0.66, alpha: 1))
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if animationBar {
            self.searchBarClosed()
        }
        self.viewBoundSearch.layer.cornerRadius = 10
    }
    
    func setClearButtonVisible(isVisible: Bool) {
        viewDeleteText.isHidden = !isVisible
        
        if isVisible {
            viewDeleteTextHeight.constant = 40
        } else {
            viewDeleteTextHeight.constant = 0
        }
    }
    
    func setText(text: String?) {
        textFieldSearch.text = text
        if let text = text, !text.isEmpty {
            setClearButtonVisible(isVisible: true)
        } else {
            setClearButtonVisible(isVisible: false)
        }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.delegate?.textFieldEnd?(text: textField.text ?? "")
        return true
    }
    
    // MARK: - Actions
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let textSearch = textFieldSearch.text else { return  }
        if textSearch.count > Constants.limitCharacterSearch {
            self.textFieldSearch.text = String(textSearch.prefix(Constants.limitCharacterSearch))
        }
        self.delegate?.textFieldDidChange?(text: textFieldSearch.text ?? "")
        setClearButtonVisible(isVisible: sender.text != "")
    }
    
    @IBAction func textFieldBegin(_ sender: Any) {
        self.delegate?.textFieldBegin?(text: (sender as AnyObject).text ?? "")
    }
    
    @IBAction func textFieldDidEnd(_ sender: Any) {
        self.delegate?.textFieldEnd?(text: (sender as AnyObject).text ?? "")
    }
    
    @IBAction func buttonRightBar(_ sender: Any) {
        if isSpeak {
            self.delegate?.didClickButton?(type: .speak)
        } else {
            self.delegate?.didClickButton?(type: .clear)
            self.searchBarClosed()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          self.endEditing(true)
        delegate?.textFieldShouldReturn?(text: textField.text ?? "")
        return true
    }
    
    @IBAction func buttonSearch(_ sender: Any) {
        if isExpand {
            self.delegate?.didClickButton?(type: .search)
        } else {
            self.searchBarExpand()
        }
    }
    
    @IBAction func clearTextButton(_ sender: Any) {
        textFieldSearch.text = ""
        setClearButtonVisible(isVisible: false)
        delegate?.clearTextField?()
        delegate?.didClickButton?(type: .clear)
    }
    
    func searchBarClosed(){
        if animationBar {
            self.isExpand = false
            self.constraintWidthClear.constant = 0
            self.constraintLeadingBar.constant = self.frame.size.width - self.frame.size.height
            UIView.animate(withDuration: duration) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func searchBarExpand(){
        if animationBar {
            self.isExpand = true
            self.constraintWidthClear.constant = self.frame.size.height
            self.constraintLeadingBar.constant = 3
            UIView.animate(withDuration: duration) {
                self.layoutIfNeeded()
            }
        }
    }
}
