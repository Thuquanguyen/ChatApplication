//
//  CustomRangeSeekSlider.swift
//  AIC Utilities People
//
//  Created by IchNV-D1 on 8/5/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
//import RangeSeekSlider

@IBDesignable final class CustomRangeSeekSlider {
//    var resultOptionChange: ((CGFloat,CGFloat) -> Void)?
//
//
//
//    override func setupStyle() {
//        let pink: UIColor = Constants.color.appHighlight
//        let gray: UIColor = Constants.color.appGrayText
//
//        minValue = 0.0
//        maxValue = 1000000.0
//        selectedMinValue = 0.0
//        minDistance = 100000
//
//        selectedMaxValue = 1000000.0
//        handleColor = pink
//        minLabelColor = pink
//        maxLabelColor = pink
//        colorBetweenHandles = pink
//        tintColor = gray
//
//        numberFormatter.locale = Locale(identifier: "vn_VN")
//        numberFormatter.numberStyle = .currency
//        labelsFixed = true
//        initialColor = gray
//
//        delegate = self
//    }
//
//    func refreshValue(){
//         self.setupStyle()
//    }
}


//// MARK: - RangeSeekSliderDelegate
//
//extension CustomRangeSeekSlider: RangeSeekSliderDelegate {
//
//    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMinValue minValue: CGFloat) -> String? {
//        let price = "\((Int(minValue/1000)*1000))"
//        return price.stringFromCurrency()
//    }
//
//    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue maxValue: CGFloat) -> String? {
//        let price = "\((Int(maxValue/1000)*1000))"
//        return price.stringFromCurrency()
//    }
//
//    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
//        resultOptionChange?(minValue, maxValue)
//    }
//}
