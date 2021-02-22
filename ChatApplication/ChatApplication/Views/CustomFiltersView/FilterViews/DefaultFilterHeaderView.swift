//
//  DefaultFilterHeaderView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class DefaultFilterHeaderView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var btnClose: UIView!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnRight: UIView!
    @IBOutlet weak var lbRight: UILabel!
    
    // MARK: - Properties
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }
    
    var iconClose: UIImage? {
        didSet {
            imgClose.image = iconClose
        }
    }
    
    var rightButtonTitle: String? {
        didSet {
            lbRight.text = rightButtonTitle
        }
    }
    
    // MARK: - Closures
    var didPressCloseView:(() -> ())?
    var didPressRightButton:(() -> ())?

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
        guard let view = UINib(nibName: "DefaultFilterHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        
        setTextLocalized()
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
        
        lbTitle.textColor = Constants.color.appDefaultText
        lbRight.textColor = Constants.color.appDefaultText
    }

}


extension DefaultFilterHeaderView: SubviewsLocalizable {
    func setTextLocalized() {
        title = "filter.title".localized
        rightButtonTitle = "filter.reset".localized
    }
}


extension DefaultFilterHeaderView: SubviewsLayoutable {
    func addSubviews() {
        
    }
    
    func setupAutolayoutForSubviews() {
        
    }
    
    func addGestureForSubviews() {
        btnClose.addSingleTapGesture(target: self, selector: #selector(pressCloseView))
        btnRight.addSingleTapGesture(target: self, selector: #selector(pressRightButton))
    }
}


extension DefaultFilterHeaderView {
    @objc func pressCloseView() {
        didPressCloseView?()
    }
    
    @objc func pressRightButton() {
        didPressRightButton?()
    }
}
