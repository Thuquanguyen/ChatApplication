//
//  ProposalSearchView.swift
//  AIC Utilities People
//
//  Created by TiemLV on 5/15/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

@objc
protocol ProposalSearchDelegate {
    @objc optional func textFieldDidChange(text: String)
    @objc optional func textFieldBegin()
    @objc optional func didClickButton(type: ProposalSearchView.typeButtonClick)
    @objc optional func didTouchSearch()
}

class ProposalSearchView: UIView {

    // MARK: - Outlets
    @IBOutlet var viewBoundSearch: UIView!
    @IBOutlet var viewFilter: DefaultFilterEntryButtonView!
    @IBOutlet var textField: UITextField!
    
    // MARK: - Properties
    @objc
    enum typeButtonClick: Int {
        case search
        case filter
    }
    
    // MARK: - Delegates
    weak var delegate: ProposalSearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "ProposalSearchView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let grayColor = UIColor("A4A6A8")
        textField.tintColor = grayColor
        textField.textColor = UIColor("3A454D")
        textField.delegate = self
        setLanguage()
        viewFilter.icon = #imageLiteral(resourceName: "ic_filter")
        viewFilter.addSingleTapGesture(target: self, selector: #selector(touchFilter))
    }
    
    @objc
    private func touchFilter() {
        self.delegate?.didClickButton?(type: .filter)
    }
    
    func setLanguage(){
        textField.placeholder = "optionselect.search_placeholder".localized
    }
    
    // MARK: - Actions
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        self.delegate?.textFieldDidChange?(text: sender.text ?? "")
    }
    
    @IBAction func textFieldBegin(_ sender: Any) {
        self.delegate?.textFieldBegin?()
        
    }
    
    @IBAction func buttonSearch(_ sender: Any) {
        self.delegate?.didClickButton?(type: .search)
    }

}
extension ProposalSearchView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didTouchSearch?()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldBegin?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.delegate?.textFieldDidChange?(text: self.textField.text ?? "")
        return true
    }
}
