//
//  CameraPhotoService.swift
//  TetViet
//
//  Created by vinhdd on 12/20/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

enum CameraPhotoServiceType {
    case camera, photoLibrary
}

class CameraPhotoService: NSObject {
    // MARK: - Singleton
    static var instance = CameraPhotoService()
    
    // MARK: - Closures
    private var didPickImage: ((_ image: UIImage?) -> Void)?
    
    func showScreenOf(type: CameraPhotoServiceType, canEdit: Bool = false, didDenyPermission: (() -> Void)? = nil, didPickImage: @escaping ((_ image: UIImage?) -> Void)) {
        func moveToImagePickerScreen() {
            let sourceType: UIImagePickerController.SourceType = type == .camera ? .camera : .photoLibrary
            guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
                didPickImage(nil)
                return
            }
            self.didPickImage = didPickImage
            let cameraView = UIImagePickerController()
            cameraView.delegate = self
            cameraView.sourceType = sourceType
            cameraView.allowsEditing = canEdit
            UIViewController.topViewController()?.present(cameraView, animated: true, completion: nil)
        }
        if type == .camera {
            switch Permission.cameraAuthStatus {
            case .notDetermined:
                Permission.requestCameraPermission(completion: { granted in
                    if granted {
                        moveToImagePickerScreen()
                    } else {
                        didDenyPermission?()
                    }
                })
            case .authorized:
                moveToImagePickerScreen()
            case .denied:
                didDenyPermission?()
            default: break
            }
        } else {
            switch Permission.photoAuthStatus {
            case .notDetermined:
                Permission.requestPhotoPermission(completion: { granted in
                    if granted {
                        moveToImagePickerScreen()
                    } else {
                        didDenyPermission?()
                    }
                })
            case .authorized:
                moveToImagePickerScreen()
            case .denied:
                didDenyPermission?()
            default: break
            }
        }
    }
    
    static func compressImage(sourceImage: UIImage) -> Data? {
        var compression: CGFloat = 0.9
        let maxCompression: CGFloat = 0.1
        let maxFileSize = 1000*1024;
        
        var imageData = sourceImage.jpegData(compressionQuality: compression)
        
        while ((imageData?.count)! > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = sourceImage.jpegData(compressionQuality: compression)
        }
        
        let countBytes = ByteCountFormatter()
        countBytes.allowedUnits = [.useMB]
        countBytes.countStyle = .file
        let fileSize = countBytes.string(fromByteCount: Int64(imageData!.count))
        
        print("File size: \(fileSize)")
        return imageData
    }
}

extension CameraPhotoService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: {
            guard let image = info[.originalImage] as? UIImage else {
                self.didPickImage?(nil)
                return
            }
            self.didPickImage?(image)
        })
    }
}


extension CameraPhotoService {
    static func showMultiImagesPicker(limit: Int, defaultLimit: Int = 10, optionType: String = "ảnh", didSelectImage: @escaping((_ image: UIImage?) -> ())) {
        guard let topVC = UIViewController.top() else { return }
        let imagePicker = BSImagePickerViewController()
        imagePicker.maxNumberOfSelections = limit
        
        topVC.bs_presentImagePickerController(imagePicker, animated: true, select: { (asset) in
            
        }, deselect: { (asset) in
            
        }, cancel: { (asset) in
            
        }, finish: { (assets) in
            for asset in assets {
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { (image, info) in
                    didSelectImage(image)
                }
            }
        }, completion: {
            
        }) { (limit) in
            UIAlertController.showQuickSystemAlert(title: "Thông báo", message: "Bạn được chọn tối đa \(defaultLimit) \(optionType)") {
                
            }
        }
    }
}

