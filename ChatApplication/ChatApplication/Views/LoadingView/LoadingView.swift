//
//  LoadingView.swift
//  E-Office
//
//  Created by manhnv on 4/4/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit
import FLAnimatedImage

class LoadingView : UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var imvLoading: FLAnimatedImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - View's life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let path = Bundle.main.path(forResource: "loading", ofType: "gif") {
            imvLoading.loadImage(url: URL(fileURLWithPath: path))
        }
    }
    
    class func loading(parent: UIView? = AppDelegate.shared.window, title: String? = "L10n.Loading.defaultTitle") -> LoadingView {
        let loadingView: LoadingView = LoadingView.loadFromNib()
        parent?.addSubview(loadingView)
        loadingView.fitParent()
//        loadingView.imvLoading.rotate(duration: 1.2, toValue: Float.pi * 2)
//        loadingView.show(duration: 0.5)
        return loadingView
    }
    
    func hidden(removeFromParent: Bool) {
        hide(animation: true, duration: 0.35) {
            self.imvLoading.layer.removeAllAnimations()
            self.removeFromSuperview()
        }
    }
    
}
