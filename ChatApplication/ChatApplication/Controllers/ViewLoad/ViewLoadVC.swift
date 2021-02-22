//
//  ViewLoadVC.swift
//  YTeThongMinh
//
//  Created by Apple on 10/15/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

class ViewLoadVC: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    deinit {
        indicator.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
    }

}
