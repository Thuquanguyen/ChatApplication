//
//  DefaultFilterShowResultButtonView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class DefaultFilterShowResultButtonView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lbTitle: UILabel!

    // MARK: - Properties
    var title: String? {
        didSet {
            lbTitle.text = title
        }
    }
    
    // MARK: - Closures
    var didPressButton:(() -> ())?
    
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
        guard let view = UINib(nibName: "DefaultFilterShowResultButtonView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        
        setTextLocalized()
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
        
        containerView.backgroundColor = Constants.color.appHighlightButton
        lbTitle.textColor = Constants.color.appHighlightTextButton
    }
    
}


extension DefaultFilterShowResultButtonView: SubviewsLocalizable {
    func setTextLocalized() {
        title = "filter.show_result".localized
    }
}


extension DefaultFilterShowResultButtonView: SubviewsLayoutable {
    func addSubviews() {
        
    }
    
    func setupAutolayoutForSubviews() {
        
    }
    
    func addGestureForSubviews() {
        containerView.addSingleTapGesture(target: self, selector: #selector(pressButton))
    }
}


extension DefaultFilterShowResultButtonView {
    @objc func pressButton() {
        didPressButton?()
    }
}
