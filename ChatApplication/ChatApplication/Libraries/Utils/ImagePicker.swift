//
//  ImagePicker.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 5/30/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit
import AVFoundation

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?, type: String?)
}


open class ImagePicker: NSObject {
    
    private var pickerController: UIImagePickerController?
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController? = nil, delegate: ImagePickerDelegate) {
        super.init()
        
        self.pickerController = UIImagePickerController()
        self.pickerController?.delegate = self
        self.pickerController?.mediaTypes = ["public.image"]
        self.pickerController?.modalPresentationStyle = .overFullScreen
        if presentationController == nil, let vc = delegate as? UIViewController {
            self.presentationController = vc
        } else {
            self.presentationController = presentationController
        }
        self.delegate = delegate
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if type == .camera {
                if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                    //already authorized
                    DispatchQueue.main.async { [weak self] in
                        if let pickerController = self?.pickerController {
                            pickerController.sourceType = type
                            self?.presentationController?.present(pickerController, animated: true)
                        }
                    }
                } else {
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (granted: Bool) in
                        if granted {
                            //access allowed
                            DispatchQueue.main.async { [weak self] in
                                if let pickerController = self?.pickerController {
                                    pickerController.sourceType = type
                                    self?.presentationController?.present(pickerController, animated: true)
                                }
                            }
                        } else {
                            //access denied
                            UIAlertController.showSystemAlert(target: self?.presentationController, title: "Thông báo", message: "", buttons: ["OK", "Hủy"]) { (index, buttonText) in
                                if index == 0 {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url) //Open settings
                                    }
                                }
                            }
                        }
                    })
                }
            } else {
                self.pickerController?.sourceType = type
                self.presentationController?.present(self.pickerController!, animated: true, completion: {

                })
            }
        }
    }
    
    public func present(from sourceView: UIView? = nil, actions: [UIAlertAction] = []) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.forEach({ alertController.addAction($0) })
        if let action = self.action(for: .camera, title: "Mở Camera") {
            alertController.addAction(action)
        }
//        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
//            alertController.addAction(action)
//        }
        if let action = self.action(for: .photoLibrary, title: "Mở thư viện") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        
        if sourceView != nil {
            if UIDevice.current.userInterfaceIdiom == .pad {
                alertController.popoverPresentationController?.sourceView = sourceView
                alertController.popoverPresentationController?.sourceRect = sourceView!.bounds
                alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
            }
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, imageType: String? = nil) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image, type: imageType)
    }
    
    //MARK: If open camera first, then open library, the library not show navigation item (title, cancel). So re init will resolve this
    private func resetPickerController() {
        self.pickerController = UIImagePickerController()
        self.pickerController?.delegate = self
        self.pickerController?.mediaTypes = ["public.image"]
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if picker.sourceType == .camera {
           resetPickerController()
        }
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        
        if picker.sourceType == .camera {
            resetPickerController()
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

extension ImagePicker: UINavigationControllerDelegate {
    
}
