//
//  PhotoPicker.swift
//  YTeThongMinh
//
//  Created by DatTV on 6/9/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//


import UIKit

open class PhotoPicker: NSObject {
    
    private static var instance = PhotoPicker()
    
    private var pickerController: UIImagePickerController!
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    private var callback: ((_ image: UIImage?) -> Void)? = nil
    
    public override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        pickerController.modalPresentationStyle = .overFullScreen
    }
    
    private func getRootVC() -> UIViewController? {
        return AppDelegate.shared.window?.rootViewController
    }
        
    static func show(_ callback: ((_ image: UIImage?) -> Void)? = nil) {
        instance.callback = callback
    }

    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, imageType: String? = nil) {
        controller.dismiss(animated: true, completion: nil)
        callback?(image)
        callback = nil
    }

}

extension PhotoPicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        
        if picker.sourceType == .camera {
            self.pickerController(picker, didSelect: image, imageType: Constants.ImageType.jpg.rawValue)
            return
        }
        
        guard let assetPathAbsoluteString = (info[UIImagePickerController.InfoKey.referenceURL] as? NSURL)?.absoluteString?.lowercased() else {
            self.pickerController(picker, didSelect: nil)
            return
        }
        
        var imageExtension: String?
        
        if (assetPathAbsoluteString.hasSuffix(Constants.ImageType.jpg.rawValue)) {
            imageExtension = Constants.ImageType.jpg.rawValue
        } else if (assetPathAbsoluteString.hasSuffix(Constants.ImageType.jpeg.rawValue)) {
            imageExtension = Constants.ImageType.jpeg.rawValue
        } else if (assetPathAbsoluteString.hasSuffix(Constants.ImageType.png.rawValue)) {
            imageExtension = Constants.ImageType.png.rawValue
        } else if (assetPathAbsoluteString.hasSuffix(Constants.ImageType.gif.rawValue)) {
            imageExtension = Constants.ImageType.gif.rawValue
        } else if (assetPathAbsoluteString.hasSuffix(Constants.ImageType.heic.rawValue)) {
            imageExtension = Constants.ImageType.heic.rawValue
        } else {
            imageExtension = nil
        }
        
        self.pickerController(picker, didSelect: image, imageType: imageExtension)
    }
}

extension PhotoPicker: UINavigationControllerDelegate {
    
}

