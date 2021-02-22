//
//  Alert.swift
//  YTeThongMinh
//
//  Created by ThuNQ on 6/1/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import UIKit

func customAler(title: String,vc: UIViewController){
    let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}
