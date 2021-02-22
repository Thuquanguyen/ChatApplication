//
//  NaviBar.swift
//  Develop
//
//  Created by quannh on 4/2/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class CustomNaviBar: UIView {
 
    // MARK: - Outlets
    @IBOutlet weak var backButtonLeft: NSLayoutConstraint!
    @IBOutlet weak var imageCenterView: UIImageView!
    @IBOutlet weak var saparateView: UIView!
    @IBOutlet weak var buttonBackView: UIView!
    @IBOutlet var constraintToTop: NSLayoutConstraint!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelLeftTitle: UILabel!
    @IBOutlet var buttonBack: ImageButton!
    @IBOutlet var imageBGBar: UIImageView!
    @IBOutlet weak var rightButtonFirst: ImageButton!
    @IBOutlet weak var rightButtonSecond: ImageButton!
    @IBOutlet weak var labelNumberNoti: UILabel!
    @IBOutlet weak var viewNumberNoti: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBInspectable var viewBackgroundColor: UIColor? {
        didSet {
            if let bgColor = viewBackgroundColor {
                imageBGBar.image = nil
                imageBGBar.backgroundColor = bgColor
            }
        }
    }
    
    @IBInspectable var title : String? {
        didSet {
            self.labelTitle.text = title
        }
    }
    var isFromChat: Bool = false
    var isShowNoti: Bool = false {
        didSet {
            viewNumberNoti.isHidden = !isShowNoti
        }
    }
    
    @objc
    enum TypeButtonClick: Int {
        case back
        case rightFirst
        case rightTwo
    }
    
    var isShowSaparate: Bool = false {
        didSet {
            saparateView.isHidden = !isShowSaparate
        }
    }
    
    var imageBackground: UIImageView? = nil {
        didSet {
            if let image = imageBackground {
                imageBGBar = image
            }
        }
    }
    
    var alphaNavi: CGFloat = 0 {
        didSet {
            labelTitle.alpha = alphaNavi
            imageBGBar.alpha = alphaNavi
        }
    }
    
    var titleLeft = "" {
        didSet {
            labelLeftTitle.text = titleLeft
        }
    }
    
    var titleBack = "Back" {
        didSet {
            buttonBack.titleLabel?.text = titleBack
        }
    }
    
    var isShowBack: Bool = true {
        didSet {
            buttonBack.isHidden = !isShowBack
            labelLeftTitle.isHidden = !isShowBack
        }
    }
    
    var isHiddenImageBackGround = false {
        didSet {
            imageBGBar.isHidden = isHiddenImageBackGround
        }
    }
    
    var imageCenter: UIImage? {
        set(value) {
            imageCenterView.isHidden = false
            imageCenterView.image = value
        }
        get {
            return imageCenterView.image
        }
    }
    
    var itemColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)/*UIColor(red: 0.22, green: 0.22, blue: 0.19, alpha: 1)*/ {
        didSet{
            buttonBack.tintColor = itemColor
            labelTitle.textColor = itemColor
        }
    }
    
    // MARK: - Closures
    var didClickBack: (() -> Void)?
    var showNotification: (() -> Void)?
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "CustomNaviBar", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        isShowNoti = false
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.262745098, blue: 0.262745098, alpha: 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.textColor = itemColor
        constraintToTop.constant = SystemInfo.statusBarHeight
    }

    // MARK: - Actions
    @IBAction func buttonBack(_ sender: Any) {
        didClickBack?()
        if isFromChat {return}
    }
    
    func setColorIconBack(_ color: UIColor) {
        self.buttonBack.imageColor = color
    }
    
    @IBAction func actionNotificationButtonTapped(_ sender: Any) {
        showNotification?()
    }
    
}
