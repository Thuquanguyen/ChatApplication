//
//  SearchResultView.swift
//  AIC Utilities People
//
//  Created by Nguyen Huu Quan on 6/11/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class SearchResultView: UIView, UITextFieldDelegate {

    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var viewBoundSearch: UIView!
    @IBOutlet weak var labelTypePlace: UILabel!
    @IBOutlet weak var imageTypePlace: UIImageView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    enum TypeActionMapSearch {
        case deletePlaceType
        case search
        case clear
        case textFieldChange
        case textFieldBegin
        case textFieldReturn
    }
    
    var didAction: ((_ type: TypeActionMapSearch, _ text: String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "SearchResultView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintTop.constant = SystemInfo.statusBarHeight
        viewBoundSearch.setCorner(8)
    }
    
    @IBAction func buttonSearch(_ sender: Any) {
        didAction?(.search, textFieldSearch.text)
    }
    
    @IBAction func buttonClear(_ sender: Any) {
        textFieldSearch.text = nil
        didAction?(.clear, textFieldSearch.text)
    }
    
    @IBAction func buttonDeleteType(_ sender: Any) {
        didAction?(.deletePlaceType, textFieldSearch.text)
    }
    
    @IBAction func textFieldChange(_ sender: Any) {
        didAction?(.textFieldChange, textFieldSearch.text)
    }
    
    @IBAction func textFieldBegin(_ sender: Any) {
        didAction?(.textFieldBegin, textFieldSearch.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didAction?(.textFieldReturn, textField.text)
        return true
    }
    
    func addSearchTextToHistory(typeSearch: CategoryType){
        if let searchText = textFieldSearch.text, searchText != "" {
            let searchService = SearchHistoryService()
            let dataHistory = searchService.loadHistory(type: typeSearch).filter({ $0.text != nil }).map({ $0.text! })
            let isHave = dataHistory.contains(searchText)
            if !isHave {
                let searchService = SearchHistoryService()
                searchService.saveSearchText(text: searchText,type: typeSearch)
            }
        }
    }
}
