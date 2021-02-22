//
//  PlayerView.swift
//  AIC Utilities People
//
//  Created by TiemLV on 5/31/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    
    var previewVideoImageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = Constants.defaultImage
        image.clipsToBounds = true
        return image
    }()
    
    lazy private var playImageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = setPlayIcon
        return image
    }()
    
    var didTouchUpInside: (() -> Void)?
    
    var isPlayVideo: Bool = false {
        didSet {
            playImageView.isHidden = !isPlayVideo
        }
    }
    
    // MARK: - IBInspectables
    
    var playImageSize: CGSize = .zero {
        didSet {
            layoutIfNeeded()
        }
    }
    
    var setPlayIcon: UIImage = #imageLiteral(resourceName: "play_audio") {
        didSet {
            playImageView.image = setPlayIcon
        }
    }
    
    
    var url: String? {
        didSet {
           setupYoutube()
        }
    }
    
    lazy var gesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(touchUpInsideVideo(_:)))
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        addSubview(previewVideoImageView)
        previewVideoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        previewVideoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        previewVideoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        previewVideoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addSubview(playImageView)
        playImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playImageView.widthAnchor.constraint(equalToConstant: self.bounds.height / 3).isActive = true
        playImageView.heightAnchor.constraint(equalToConstant: self.bounds.height / 3).isActive = true
        
        isPlayVideo = false
        
        addGestureRecognizer(gesture)
    }
    
    
    @objc
    func touchUpInsideVideo(_ tapGesture: UITapGestureRecognizer) {
        didTouchUpInside?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            return super.hitTest(point, with: event)
        }
        guard isUserInteractionEnabled, !isHidden, alpha > 0 else {
            return nil
        }

        return nil
    }
    
    func setupYoutube() {
        guard let url = self.url else { return }
    }
}
