//
//  AlertView.swift
//  E-Office
//
//  Created by manhnv on 4/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class AlertView : UIView {

    // MARK: - Properties
    var viewBackGround: UIView!
    var viewContent: UIView!
    var btnClose: UIButton!
    var lblTitle: UILabel?
    var lblContent: UILabel?
    var imvContent: UIImageView?
    var btnAccept: UIButton?
    var lastSubviewBottomAnchor: NSLayoutYAxisAnchor!
    var removeAlert: Bool = false
    
    // MARK: - Closures
    var btnCloseAction: (()->())?
    var btnAcceptAction: (()->())?
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func showAlert(title: String? = nil,
                         titleAttribute: NSAttributedString? = nil,
                         image: UIImage? = nil,
                         tintcolor: UIColor? = nil,
                         imageSize: CGSize = .zero,
                         content: String? = nil,
                         contentAttribute: NSAttributedString? = nil,
                         accept: String? = "OK",
                         removeAlert: Bool = false,
                         acceptAction: (() -> ())? = nil) -> AlertView {
        
        let alert = AlertView()
        alert.backgroundColor = .clear
        alert.clipsToBounds = true
        alert.removeAlert = removeAlert
        
        alert.setupBackGround()
        alert.setupViewContent()
        alert.setupCloseButton()

        if title != nil || titleAttribute != nil {
            alert.setupTitle(title,attribute: titleAttribute)
        }
        
        if let image = image {
            alert.setupImage(image, tincolor: tintcolor, size: imageSize)
        }
        
        if content != nil || contentAttribute != nil {
            alert.setupContentLabel(content,attribute: contentAttribute)
        }
        
        if let accept = accept {
            alert.setupAcceptButton(accept: accept)
            alert.btnAcceptAction = acceptAction
        }
        
        alert.viewContent.bottomAnchor.constraint(equalTo: alert.lastSubviewBottomAnchor, constant: 16).isActive = true
        
        return alert
    }
    
    fileprivate func setupBackGround() {
        viewBackGround = UIView()
        addSubview(viewBackGround)
        viewBackGround.translatesAutoresizingMaskIntoConstraints = false
        viewBackGround.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        viewBackGround.fitParent()
    }
    
    fileprivate func setupViewContent() {
        
        viewContent = UIView()
        addSubview(viewContent)
        viewContent.backgroundColor = .white
        viewContent.layer.masksToBounds = true
        viewContent.layer.cornerRadius = 4
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        viewContent.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        viewContent.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        viewContent.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        lastSubviewBottomAnchor = viewContent.topAnchor
        
    }
    
    
    fileprivate func setupCloseButton(_ image: UIImage? = UIImage()) {
        
        btnClose = UIButton(type: .system)
        viewContent.addSubview(btnClose)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.setImage(image, for: .normal)
        btnClose.contentMode = .scaleAspectFit
        btnClose.tintColor = Constants.color.gray
        btnClose.imageEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 25, right: 0)
        
        btnClose.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 20).isActive = true
        btnClose.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: -16).isActive = true
        btnClose.widthAnchor.constraint(equalToConstant: 40).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnClose.addTarget(self, action: #selector(btnCloseTouchInside), for: .touchUpInside)
    }
    
    fileprivate func setupTitle(_ title: String?, attribute: NSAttributedString?) {
        
        lblTitle = UILabel()
        viewContent.addSubview(lblTitle!)
        lblTitle?.numberOfLines = 0
        lblTitle?.translatesAutoresizingMaskIntoConstraints = false
        lblTitle?.font = Constants.font.lato(type: .medium)
        lblTitle?.text = title
        lblTitle?.textColor = .black
        lblTitle?.textAlignment = .center
        
        if let attribute = attribute {
            lblTitle?.attributedText = attribute
        }
        
        lblTitle?.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 25).isActive = true
        lblTitle?.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor).isActive = true
        lblTitle?.trailingAnchor.constraint(lessThanOrEqualTo: btnClose.leadingAnchor, constant: -10).isActive = true
        lastSubviewBottomAnchor = lblTitle?.bottomAnchor
    }
    
    
    fileprivate func setupImage(_ image: UIImage, tincolor: UIColor? , size: CGSize) {
        
        imvContent = UIImageView(image: image)
        viewContent.addSubview(imvContent!)
        if tincolor != nil {
            imvContent?.tintColor = tincolor
            imvContent?.image = image.withRenderingMode(.alwaysTemplate)
        }
        imvContent?.translatesAutoresizingMaskIntoConstraints = false
        imvContent?.contentMode = .scaleAspectFit
        
        imvContent?.topAnchor.constraint(equalTo: lastSubviewBottomAnchor, constant: 20).isActive = true
        imvContent?.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor).isActive = true
        imvContent?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        imvContent?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        lastSubviewBottomAnchor = imvContent?.bottomAnchor
        
    }
    
    fileprivate func setupContentLabel(_ content: String?, attribute: NSAttributedString?) {
        
        lblContent = UILabel()
        viewContent.addSubview(lblContent!)
        lblContent?.numberOfLines = 0
        lblContent?.translatesAutoresizingMaskIntoConstraints = false
        lblContent?.font = Constants.font.lato(type: .regular)
        lblContent?.text = content
        lblContent?.textAlignment = .center
        lblContent?.textColor = .black
        
        
        if let attribute = attribute {
            lblContent?.attributedText = attribute
        }
        
        if lblTitle == nil && imvContent == nil {
            lblContent?.topAnchor.constraint(equalTo: lastSubviewBottomAnchor, constant: 35).isActive = true
        } else {
            lblContent?.topAnchor.constraint(equalTo: lastSubviewBottomAnchor, constant: 25).isActive = true
        }
        lblContent?.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor).isActive = true
        lblContent?.trailingAnchor.constraint(lessThanOrEqualTo: viewContent.trailingAnchor, constant: -25).isActive = true
        lastSubviewBottomAnchor = lblContent?.bottomAnchor
        
    }
    
    fileprivate func setupAcceptButton(accept title: String) {
        btnAccept = UIButton()
        viewContent.addSubview(btnAccept!)
        btnAccept?.translatesAutoresizingMaskIntoConstraints = false
        btnAccept?.setTitle(title, for: .normal)
        btnAccept?.titleLabel?.font = Constants.font.lato(type: .medium, size: 16)
        btnAccept?.setTitleColor(.white, for: .normal)
        btnAccept?.backgroundColor = Constants.color.appHighlight
        
        btnAccept?.topAnchor.constraint(equalTo: lastSubviewBottomAnchor, constant: 25).isActive = true
        btnAccept?.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 16).isActive = true
        btnAccept?.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor).isActive = true
        btnAccept?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lastSubviewBottomAnchor = btnAccept?.bottomAnchor
        btnAccept?.addTarget(self, action: #selector(btnAcceptTouchInside), for: .touchUpInside)
    }
    
    @objc func btnCloseTouchInside() {
        btnCloseAction?()
       hidePopUp()
    }
    
    func hidePopUp() {
        self.hide(animation: true, duration: 0.3) {
            self.removeFromSuperview()
        }
    }
    
    @objc func btnAcceptTouchInside() {
        if let btnAcceptAction = btnAcceptAction {
            if removeAlert {
                hidePopUp()
            }
            btnAcceptAction()
        } else {
            btnCloseTouchInside()
        }
    }
    
}
