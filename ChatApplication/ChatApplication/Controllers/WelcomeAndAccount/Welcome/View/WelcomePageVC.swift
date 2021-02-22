//
//  WelcomePageVC.swift
//  YTeThongMinh
//
//  Created by QuanNH on 5/27/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

class WelcomePageVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageLine: UIImageView!
    
    // MARK: - Properties
    var index: Int = 0
    var image: UIImage?
    var titleSplat: String = ""
    var line: String = ""

    // MARK: - ViewController's life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        imageContent.image = image
        labelTitle.text = titleSplat
        imageLine.image = UIImage(named: line)
    }

}
