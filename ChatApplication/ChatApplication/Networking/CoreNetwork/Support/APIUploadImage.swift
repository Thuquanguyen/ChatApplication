//
//  APIUploadImage.swift
//  YTeThongMinh
//
//  Created by QuanNH on 6/12/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import UIKit

public class APIUploadImage {
    var mineType: String = ""
    var fileName = ""
    var keyName = ""
    var image: UIImage?
    var data: Data?
    
    init(image: UIImage?, fileName: String? = "image.jpg", keyName: String = "image", mineType: String = "image/jpeg") {
        self.mineType = mineType
        self.fileName = fileName ?? "image.jpg"
        self.keyName = keyName
        self.image = image
        if fileName?.hasSuffix(".png") ?? false {
            self.data = image?.pngData()
        } else {
            self.data = image?.jpegData(compressionQuality: 1)
        }
    }
}
