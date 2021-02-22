//
//  RatingStar.swift
//  AIC Utilities People
//
//  Created by Datt-D1 on 5/16/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    
    var ratingButtons = [ImageButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGFloat = 24 {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var isEnabledStar: Bool = true {
        didSet {
            ratingButtons.forEach { (button) in
                button.isUserInteractionEnabled = isEnabledStar
            }
        }
    }
    
    @IBInspectable var starSpace: CGFloat = 0 {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var imageSelected: UIImage = #imageLiteral(resourceName: "ic_star_selected.pdf")
    @IBInspectable var imageDiselected: UIImage = #imageLiteral(resourceName: "ic_star_diselected.pdf")
    
    var didSelectStar: ((Int) -> Void)? = nil
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
       
        setupButtons()
    }
    
    private func setupButtons() {
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
        for button in arrangedSubviews {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()

        for _ in 0..<starCount {
            let button = ImageButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize).isActive = true
            button.sizeIcon = starSize
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
     
     @objc func ratingButtonTapped(button: ImageButton) {
         if !isEnabledStar {
             return
         }
         guard let index = ratingButtons.index(of: button) else {
             fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
         }
         rating = index + 1
         didSelectStar?(rating)
     }
    
    func updateButtonSelectionStates() {
        
        for (index, button) in ratingButtons.enumerated() {
            button.iconImage = index < rating ? imageSelected : imageDiselected
        }
    }
 
}
