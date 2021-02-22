//
//  FillerPeople.swift
//  AIC Utilities People
//
//  Created by IchNV-D1 on 5/9/19.
//  Copyright © 2019 IchNV-D1. All rights reserved.
//

import UIKit
@objc
protocol FillerPeopleDelegate {
    @objc optional func didClickButtonFiller(type: FillerPeople.TypeButton)
}

class FillerPeople: UIView {
    
    @objc
    enum TypeButton: Int {
        case unit
        case category
        case level
    }
    
    // MARK: - Delegates
    weak var delegate: FillerPeopleDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var categoryButton: ShadowButton!
    @IBOutlet weak var unitButton: ShadowButton!
    @IBOutlet weak var levelButton: ShadowButton!
    
    // MARK: - Properties
    var categoryName: String? = "Tất cả" {
        didSet{
            categoryButton.setTitle(categoryName, for: .normal)
        }
    }
    
    var levelName: String? = "Tất cả" {
        didSet{
            levelButton.setTitle(levelName, for: .normal)
        }
    }
    
    var unitName: String? = "Tất cả" {
        didSet{
            unitButton.setTitle(unitName, for: .normal)
        }
    }
    
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
        guard let view = UINib(nibName: "FillerPeople", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        self.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    // MARK: - Actions
    @IBAction func pressUnit(_ sender: Any) {
        self.delegate?.didClickButtonFiller?(type: .unit)
    }
    
    @IBAction func pressCategory(_ sender: Any) {
        self.delegate?.didClickButtonFiller?(type: .category)
    }
    
    @IBAction func pressLevel(_ sender: Any) {
        self.delegate?.didClickButtonFiller?(type: .level)
    }
}
