//
//  NavigationView.swift
//  Develop
//
//  Created by NghiaMV-D3 on 12/25/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class NavigationView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundLeftBtnView: UIView!
    @IBOutlet weak var backgroundRightBtnView: UIView!
    @IBOutlet weak var imagePeachBlossom: UIImageView!
    @IBOutlet weak var cstWidthLeftBtn: NSLayoutConstraint!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewEmpty: UIView!
    
    // MARK: - Closures
    var actionLeftTapped: (() -> Void)?
    var actionRightTapped: (() -> Void)?
    
    /// screen code, category, sub category id
    private var searchInput: (String, String, String)?
    private var imgLeft: UIImage?
    private var imgRight: UIImage?
    private var topTitle: String?
    private var isCenterTitle = false
    private var mainColor: UIColor?
    
    var rightCompressLayoutImage: UIImage? {
        return !UITableView.isCompressLayout ? "ic_uncomPress".image : "ic_compress".image
    }
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInitialization()
    }
    
  override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setStatusBarStyle()
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            setStatusBarStyle()
        }
    }
    
    func setStatusBarStyle() {
        if let vc = viewContainingController() as? BaseVC {
            if backgroundColor == nil || backgroundColor == UIColor.white {
                vc.statusBarStyle = .default
            } else {
                vc.statusBarStyle = .lightContent
            }
        }
    }

    func commonInitialization() {
        let view = Bundle.main.loadNibNamed("NavigationView", owner: self, options: nil)?.first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.backgroundColor = .clear
        NSLayoutConstraint.activate([
        view.bottomAnchor.constraint(equalTo: bottomAnchor),
        view.leadingAnchor.constraint(equalTo: leadingAnchor),
        view.trailingAnchor.constraint(equalTo: trailingAnchor),
        view.topAnchor.constraint(equalTo: topAnchor),
        ])
        btnSearch.setImage("ic_search".image?.filledImage(fillColor: .init(hexa: "34404B")), for: .normal)
        imagePeachBlossom.isHidden = true
        backgroundLeftBtnView.isHidden = true
        backgroundRightBtnView.isHidden = true
        backgroundLeftBtnView.setCorner(backgroundLeftBtnView.frame.size.height / 2)
        backgroundRightBtnView.setCorner(backgroundRightBtnView.frame.size.height / 2)
    }
    
    func animateBackgroundLeftBtnView(alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.backgroundLeftBtnView.alpha = alpha
        }
    }
    
    func animateTitle(alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.lblTitle.alpha = alpha
        }
    }
    
    func setupView(){
        if let imgLeft = imgLeft {
            btnLeft.isHidden = false
            btnLeft.setImage(imgLeft, for: .normal)
        } else {
            btnLeft.isHidden = true
        }
        if let imgRight = imgRight {
            btnRight.isHidden = false
            btnRight.setImage(imgRight, for: .normal)
            viewEmpty.isHidden = true
        } else {
            btnRight.isHidden = true
            viewEmpty.isHidden = false
        }
        if let topTitle = topTitle {
            lblTitle.isHidden = false
            lblTitle.text = topTitle
            lblTitle.textAlignment = isCenterTitle ? .center : .left
        } else {
            lblTitle.isHidden = true
        }
        if let mainColor = mainColor {
            //btnLeft.setImage(imgLeft?.filledImage(fillColor: mainColor), for: .normal)
//            btnRight.setImage(imgRight?.filledImage(fillColor: mainColor), for: .normal)
            lblTitle.textColor = mainColor
        }
    }
    
    func customView(leftImage: UIImage? = Constants.backImage, rightImage: UIImage?, title: String?, titleCenter: Bool = false, mainColor: UIColor? = nil, isSetWidthLeftBtn: Bool = false, backgroundColor: UIColor? = nil, fontTitle: UIFont? = nil){
        self.cstWidthLeftBtn.constant = isSetWidthLeftBtn ? 158 : 44
        self.imgLeft = leftImage
        self.imgRight = rightImage
        self.topTitle = title
        self.isCenterTitle = titleCenter
        self.mainColor = mainColor
        if let font = fontTitle {
            self.lblTitle.font = font
        }
        self.backgroundColor = backgroundColor
        setupView()
    }
    
    func customeChangeColor(isBlack: Bool = false) {
        if isBlack {
            btnRight.setImage(imgRight?.filledImage(fillColor: .init(hexa: "34404B")), for: .normal)
            btnSearch.setImage("ic_search".image?.filledImage(fillColor: .init(hexa: "34404B")), for: .normal)
            btnLeft.setImage(imgLeft?.filledImage(fillColor: .init(hexa: "34404B")), for: .normal)
        } else {
            btnRight.setImage(imgRight?.filledImage(fillColor: .white), for: .normal)
            btnSearch.setImage("ic_search".image?.filledImage(fillColor: .init(hexa: "FFFFFF")), for: .normal)
            btnLeft.setImage(imgLeft?.filledImage(fillColor: .white), for: .normal)
        }
    }
    
    func enableSubSearch(screenCode: String, category: String, subid: String) {
        searchInput = (screenCode, category, subid)
        btnSearch.isHidden = false
    }
    
    func setLeftBtnColor(_ color: UIColor) {
        btnLeft.setImage(imgLeft?.filledImage(fillColor: color), for: .normal)
    }
    
    func setRightBtnColor(_ color: UIColor) {
        btnRight.setImage(imgRight?.filledImage(fillColor: color), for: .normal)
    }
    
    func setRightButton(image: UIImage?) {
        self.imgRight = image
        setupView()
    }
    
    // MARK: - Actions
    @IBAction func onTappedLeft(_ sender: Any) {
        if let _ = actionLeftTapped {
            actionLeftTapped?()
        } else {
            VCService.pop()
        }
    }
    
    @IBAction func onTappedRight(_ sender: Any) {
        actionRightTapped?()
    }
    
    @IBAction func actionSearch(_ sender: Any) {

    }
}


//MARK: switch compress UI
extension UITableView {
    private static var _isCompressLayout = [String:Bool]()
    
    static var isCompressLayout:Bool {
        get {
            let tmpAddress = "_isCompressLayout"
            return UserDefaults.standard.bool(forKey: tmpAddress)
        }
        set(newValue) {
            let tmpAddress = "_isCompressLayout"
            UserDefaults.standard.set(newValue, forKey: tmpAddress)
        }
    }
}
