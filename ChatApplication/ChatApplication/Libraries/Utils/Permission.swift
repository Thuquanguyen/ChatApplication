//
//  Permission.swift
//  TetViet
//
//  Created by vinhdd on 12/14/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import Photos
import Contacts
import UserNotifications

class Permission {
    
    static var cameraAuthStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    static func requestCameraPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch Permission.cameraAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    static var photoAuthStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    static func requestPhotoPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch Permission.photoAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        }
    }
    
    static var recordStatus: AVAudioSession.RecordPermission {
        return AVAudioSession.sharedInstance().recordPermission
    }
    
    static func requestRecordPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch recordStatus {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        default:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    static var locationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    static var contactStatus: CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }
    
    static func requestContactsPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch contactStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            CNContactStore().requestAccess(for: .contacts) { (granted, _) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    static func getNotificationAuthorStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        })
    }
    
    static func alertToSetting(vc: UIViewController){
        let alertTitle = "Thông báo"
        let message = "Bạn chưa cấp quyền truy cập camera cho ứng dụng"
        let okTitle = "Cài đặt"
        let cancelTitle = "Huỷ"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style: .default) { (alert) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        let cancel = UIAlertAction(title: cancelTitle, style: .default) { (alert) in
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func requestCameraAndMicrophonePermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch Permission.cameraAuthStatus {
        case .authorized:
            Permission.requestRecordPermission(completion: completion)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        Permission.requestRecordPermission(completion: completion)
                    } else {
                        completion(false)
                    }
                }
            }
        @unknown default:
            completion(false)
        }
    }
}
