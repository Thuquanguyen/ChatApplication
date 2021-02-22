//
//  ImagesPageView.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/31/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class ImagesPageView: UIView {
    
    // MARK: - Properties
    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isPagingEnabled = true
        v.alwaysBounceHorizontal = true
        v.alwaysBounceVertical = false
        v.showsHorizontalScrollIndicator = false
        v.delegate = self
        return v
    }()

    lazy var pageControl: UIPageControl = {
        let v = UIPageControl()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfPages = 1
        v.currentPage = 0
        v.pageIndicatorTintColor = Constants.color.lightColor
        v.currentPageIndicatorTintColor = UIColor.white
        v.isUserInteractionEnabled = false
        return v
    }()
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ImagesPageView: SubviewsLayoutable {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(scrollView)
        containerView.addSubview(pageControl)
    }
    
    func setupAutolayoutForSubviews() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0),

            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            scrollView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0),
            scrollView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0),

            pageControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0),
            pageControl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0),
            pageControl.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0),
            pageControl.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    }
    
    func addGestureForSubviews() {

    }
}


extension ImagesPageView {
    func configScrollViewWithImages(images: [String]) {
        let padding : CGFloat = 0.0
        let viewWidth = scrollView.frame.size.width - 2*padding
        let viewHeight = scrollView.frame.size.height - 2*padding
        
        var x : CGFloat = 0
        
        var arrImages = images
        
        if images.isEmpty == true {
            arrImages = [""]
        }
        
        for imageURLString in arrImages {
            let imgView: UIImageView = UIImageView(frame: CGRect(x: x + padding, y: padding, width: viewWidth, height: viewHeight))
            imgView.contentMode = .scaleAspectFill
            imgView.loadImage(url: URL.init(string: imageURLString))
            scrollView.addSubview(imgView)
            x = imgView.frame.origin.x + viewWidth + padding
        }
        
        scrollView.contentSize = CGSize(width:x+padding, height:scrollView.frame.size.height)
    }
    
    func updatePageControl(numberPages: Int, currentPage: Int) {
        pageControl.numberOfPages = numberPages
        pageControl.currentPage = currentPage
    }
}


extension ImagesPageView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
