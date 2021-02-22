//
//  DropDownLanguageView.swift
//  AIC Utilities People
//
//  Created by TiemLV on 6/14/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

struct OptionLanguage {
    
    var image: String?
    var subLanguageTitle: String?
    var language: String?
}

class DropDownLanguageView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var boderView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var iconLanguageImage: UIImageView!
    @IBOutlet weak var subTitleLanguageLabel: UILabel!
    @IBOutlet weak var languageTitle: UILabel!
    @IBOutlet weak var optionLanguageLabel: UILabel!
    
    // MARK: - Properties
    var isSeletedLanguage: Bool = false {
        
        didSet {
            languageView.isHidden = !isSeletedLanguage
            optionLanguageLabel.isHidden = isSeletedLanguage
        }
    }
    
    var language: OptionLanguage? {
        didSet {
            isSeletedLanguage = language != nil
            subTitleLanguageLabel.text = language?.subLanguageTitle
            languageTitle.text = language?.language
            iconLanguageImage.image = UIImage(named: language?.image ?? "")
        }
    }
    
    var selectLanguageText: String? {
        didSet {
            optionLanguageLabel.text = selectLanguageText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        isSeletedLanguage = true
    }

}

extension DropDownLanguageView {
    
    private func commonInit() {
        guard let view = UINib(nibName: "DropDownLanguageView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
}
