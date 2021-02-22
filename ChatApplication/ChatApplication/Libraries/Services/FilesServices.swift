//
//  FilesServices.swift
//  AIC Utilities People
//
//  Created by IchNV-D1 on 8/23/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class FilesServices: NSObject {
    // MARK: - Singleton
    static var instance = FilesServices()
    
    // MARK: - Closures
    private var didPickFile: ((_ url: URL?,_ name: String?) -> Void)?
    
    /*
     .docx: "org.openxmlformats.wordprocessingml.document"
     .xlsx: "org.openxmlformats.spreadsheetml.sheet"
     */
    func showScreenOf(didPickFile: @escaping ((_ url: URL?,_ name: String?) -> Void)) {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), "com.adobe.doc", "com.adobe.docs", "com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", "org.openxmlformats.spreadsheetml.sheet", "com.microsoft.excel.xls"], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.popover
        self.didPickFile = didPickFile
        UIViewController.topViewController()?.present(documentPicker, animated: true, completion: nil)
    }
    
    func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void) {
        guard let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
    
}

extension FilesServices: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        _ = url.startAccessingSecurityScopedResource()
        
        let coordinator = NSFileCoordinator()
        var error: NSError? = nil
        coordinator.coordinate(readingItemAt: url, options: [], error: &error) { (url) -> Void in
            self.didPickFile?(url,url.lastPathComponent)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        controller.dismiss(animated: true, completion: nil)
    }
    
}


//extension FilesServices {
//    func prepareToDownloadFile(link: String) {
//        guard let url = URL(string: link.percentEncoding ?? "") else {
//            let alert = FieldsValidationAlertController.showErrorDialog(error: "Tải về không khả dụng!", completion: {
//                FieldsValidationAlertPresenter.instance.removeCurrentAlert()
//            })
//            VCService.present(controller: alert)
//            return
//        }
//
//        if APIUtilities.hasInternet {
//            downloadFile(url: url)
//        } else {
//            IndicatorViewer.hide()
//            showAlert(link: link)
//        }
//    }
//
//    func downloadFile(url: URL) {
//        IndicatorViewer.show()
//        FilesServices.instance.loadFileAsync(url: url, completion: { (path, error) in
//            IndicatorViewer.hide()
//
//            guard let path = path else {
//                let alert = FieldsValidationAlertController.showErrorDialog(error: "Tải về không thành công", completion: {
//                    FieldsValidationAlertPresenter.instance.removeCurrentAlert()
//                })
//                VCService.present(controller: alert)
//                return
//            }
//
//            let urlFile = URL.init(fileURLWithPath: path)
//
//            let activityViewController = UIActivityViewController(activityItems: [urlFile] , applicationActivities: nil)
//
//            DispatchQueue.main.async {
//                VCService.present(controller: activityViewController)
//            }
//        })
//    }
//}


extension FilesServices {
    func prepareToOpenFileInSafari(link: String) {
        guard let url = URL(string: link.percentEncoding ?? "") else {
            let alert = FieldsValidationAlertController.showErrorDialog(error: "Tải về không khả dụng!", completion: {
                FieldsValidationAlertPresenter.instance.removeCurrentAlert()
            })
            VCService.present(controller: alert)
            return
        }
        
        if APIUtilities.hasInternet {
            openFileInSafari(url: url)
        } else {
            IndicatorViewer.hide()
            showAlert(link: link)
        }
    }
    
    func openFileInSafari(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func showAlert(link: String) {
           let title = "alert_no_connection".localized
           let message = "alert_no_connection_try".localized
           let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let retryAction = UIAlertAction(title: "place_ratting_vote_try_again".localized, style: .default, handler: { _ in
               self.prepareToOpenFileInSafari(link: link)
           })
           let closeAction = UIAlertAction(title: "alert.default_login_close".localized, style: .default, handler: { _ in
               VCService.pop()
           })
           alertVC.addAction(retryAction)
           alertVC.addAction(closeAction)
           
           VCService.present(controller: alertVC)
       }
}
