//
//  SearchTextFieldView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/14/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol SearchTextFieldViewDelegate: AnyObject {
    func didPressSearchButton(keyword: String?)
    func didUpdateText(keyword: String?)
}

class SearchTextFieldView: UIView {
    
    // MARK: - Properties
    var lastChangeStamp: TimeInterval = Date().timeIntervalSince1970
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Constants.color.searchBackground
        v.setCorner(10.0)
        return v
    }()
    
    lazy var imgIcon: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.image = UIImage()
        return v
    }()
    
    lazy var textField: UITextField = {
        let v = UITextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.borderStyle = .none
        v.font = Constants.font.lato(type: .regular, size: 17.0)
        v.clearButtonMode = .whileEditing
        v.textColor = Constants.color.appDefaultText
        v.returnKeyType = .search
        v.delegate = self
        v.placeholder = "L10n.suppportTransalteSearch"
        v.clearButtonMode = UITextField.ViewMode.always
        return v
    }()
    
    var textFieldPlaceholder: String? {
        didSet {
            textField.placeholder = textFieldPlaceholder
        }
    }
    
    var textSearch: String? {
        didSet {
            textField.text = textSearch
        }
    }
    
    // MARK: - Delegates
    weak var delegate: SearchTextFieldViewDelegate?
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }

}


extension SearchTextFieldView: SubviewsLayoutable {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(imgIcon)
        containerView.addSubview(textField)
    }
    
    func setupAutolayoutForSubviews() {
        let margin: CGFloat = 5.0
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.0),
            
            imgIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2.0*margin),
            imgIcon.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 3.0*margin),
            imgIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2.0*margin),
            imgIcon.heightAnchor.constraint(equalTo: imgIcon.widthAnchor, multiplier: 1.0),
            
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            textField.leftAnchor.constraint(equalTo: imgIcon.rightAnchor, constant: 15.0),
            textField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -margin),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0),
            ])
    }
    
    func addGestureForSubviews() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}


extension SearchTextFieldView: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        guard let text = textField.text else { return }
        var textSearch = text.trimWhiteSpacesAndNewLines
        if textSearch.count > Constants.limitCharacterSearch {
            textField.text = String(textSearch.prefix(Constants.limitCharacterSearch))
            textSearch = textField.text ?? ""
            
            DispatchQueue.main.async {
                let end = self.textField.endOfDocument
                let range = self.textField.textRange(from: end, to: end)
                self.textField.selectedTextRange = range
            }
        }
        lastChangeStamp = Date().timeIntervalSince1970
        delay(seconds: 0.8) {
            if Date().timeIntervalSince1970 - self.lastChangeStamp >= 0.8 {
                self.delegate?.didUpdateText(keyword: textSearch)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.didPressSearchButton(keyword: textField.text?.trimWhiteSpacesAndNewLines)
        return true
    }
}
