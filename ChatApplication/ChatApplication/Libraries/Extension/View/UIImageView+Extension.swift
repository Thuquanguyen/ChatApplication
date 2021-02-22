//
//  UIImageView+Extension.swift
//  TetViet
//
//  Created by vinhdd on 12/14/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func loadImage(urlString: String?,
                   placeholder: UIImage? = Constants.defaultImage,
                   showIndicator: Bool = false,
                   forceRefresh: Bool = false,
                   completion: ((_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void)? = nil) {
        
        let url = URL(string: urlString ?? "")
        
        if showIndicator {
            UIActivityIndicatorView()
        }
        sd_imageTransition = .fade
        var options: SDWebImageOptions = []
        if forceRefresh {
            options = [.refreshCached]
        }
        sd_setImage(with: url, placeholderImage: placeholder, options: options) { [weak self] (image, error, _, url) in
            completion?(image, error, url)
        }
    }
    
    func loadImage(url: URL?,
                   placeholder: UIImage? = Constants.defaultImage,
                   showIndicator: Bool = false,
                   forceRefresh: Bool = false,
                   completion: ((_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void)? = nil) {
        if showIndicator {
            UIActivityIndicatorView()
        }
        sd_imageTransition = .fade
        var options: SDWebImageOptions = []
        if forceRefresh {
            options = [.refreshCached]
        }
        sd_setImage(with: url, placeholderImage: placeholder, options: options) { [weak self] (image, error, _, url) in
            completion?(image, error, url)
        }
    }
    
    func cancelDownloadingImage() {
        sd_cancelCurrentImageLoad()
    }
    
    func set(color: UIColor) {
        image = image?.renderTemplate()
        tintColor = color
    }
    
    func renderOriginal() {
        image = image?.renderOriginal()
    }
    
    func renderTemplate() {
        image = image?.renderTemplate()
    }
    
    func autoFullFill(_ image: UIImage? = nil) {
        if let image = image {
            self.image = image
        }
        if let image = self.image {
            let ratio = image.size.width/image.size.height
            contentMode = ratio >= 1 ? .scaleAspectFill : .scaleAspectFit
        }
    }

}
