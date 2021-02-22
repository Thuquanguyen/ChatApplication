//
//  MonthAndYearPickerViewController.swift
//  CTT_BN
//
//  Created by Duypx-D1 on 5/7/19.
//  Copyright © 2019 VietHD-D3. All rights reserved.
//

import UIKit

class MonthAndYearPickerViewController: UIViewController {

    @IBOutlet weak var monthAndYearPicker: MonthYearPickerView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var containerView: UIView!
    var didSelectDate: ((String, String) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    

    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.didSelectDate?("\(monthAndYearPicker.month)", "\(monthAndYearPicker.year)")
        self.dismiss(animated: true, completion: nil)
    }

    
}
