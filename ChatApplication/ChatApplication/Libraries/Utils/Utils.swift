//
//  Utils.swift
//  CTT_BN
//
//  Created by IchNV-D1 on 4/23/19.
//  Copyright © 2019 VietHD-D3. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SafariServices
//import FBSDKLoginKit
//import FBSDKCoreKit
//import GoogleSignIn

class Utils {
    // Check sandbox enviroment or not
    #if DEVELOP || STAGING
    static let isSandboxEnviroment: Bool = true
    #else
    static let isSandboxEnviroment: Bool = false
    #endif
    
    // Sleep app with input time interval
    
    static func sleep(_ second: TimeInterval, completion: @escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: {
            completion()
        })
    }
    
    static func mainQueue(closure: @escaping () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
    static func openUrl(string: String) {
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    static func needUpdate(remoteVer: String) -> Bool {
        guard let currentVer = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return false }
        if remoteVer.compare(currentVer, options: .numeric) == .orderedDescending {
            return true
        }
        return false
    }

    static func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func openSFSafariVC(urlString: String?) {
        guard let url = URL.init(string: urlString ?? "") else { return }
        
        let svc = SFSafariViewController(url: url)
        VCService.present(controller: svc)
    }
    
    static func splitStringWithSentence(text: String, count: Int) -> [String] {
        var paragraph: [String] = []
        let numberOfText = text.count
        if numberOfText <= count { return [text] }
        let lastIndex = numberOfText - 1
        var startIndex = 0
        let sequence: [Character] = [",",".","?","!",";",":"]
        repeat {
            let subString = text[startIndex..<(startIndex + count)]
            let lastChar = subString.suffix(1)
            if lastChar == "." {
                startIndex += count
                paragraph.append(String(subString))
            } else {
                var tempIndex = 0
                for i in (startIndex..<(startIndex + count)).reversed() {
                    if sequence.contains(subString[i - startIndex]) {
                        tempIndex = i
                        break
                    }
                }
                if tempIndex == 0 {
                    for i in (startIndex..<(startIndex + count)).reversed() {
                        if subString[i - startIndex] == " " {
                            tempIndex = i
                            break
                        }
                    }
                    if tempIndex == 0 {
                        tempIndex = startIndex + count
                    }
                    let subsubString = text[startIndex..<tempIndex]
                    startIndex = tempIndex + 1
                    paragraph.append(String(subsubString))
                } else {
                    let subsubString = text[startIndex..<tempIndex]
                    startIndex = tempIndex + 1
                    paragraph.append(String(subsubString))
                }
            }
        } while lastIndex - startIndex + 1 >= count
        if startIndex <= lastIndex {
            let remainText = text[startIndex...lastIndex]
            paragraph.append(String(remainText))
        }
        return paragraph
    }
    
    class func getImage(filename:String) -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(filename)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image
            // Do whatever you want with the image
        }
        return nil
    }
    
    class func dowloadFile(file: String ) {
        let urlFile = file
        if APIUtilities.hasInternet {
            IndicatorViewer.show()
            let urlString = file
            let url = URL(string: urlString)
            let fileName = String((url!.lastPathComponent)) as NSString
            
            // Create destination URL
            guard let documentsUrl: URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
            //Create URL to the source file you want to download
            let fileURL = URL(string: urlString)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url:fileURL!)
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                IndicatorViewer.hide()
                
                if !APIUtilities.hasInternet {
                    UIAlertController.showSystemAlert(title: "alert_no_connection".localized, message: "alert_no_connection_try".localized, buttons: ["place_ratting_vote_try_again".localized, "alert.default_login_close".localized]) { (index, buttonText) in
                        if index == 0 {
                            self.dowloadFile(file: urlFile)
                        }
                    }
                }
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                    }
                    do {
                        if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
                            try FileManager.default.removeItem(at: destinationFileUrl)
                        }
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        do {
                            //Show UIActivityViewController to save the downloaded file
                            let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                            for indexx in 0..<contents.count {
                                if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                    let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                    VCService.present(controller: activityViewController)
                                }
                            }
                        }
                        catch (let err) {
                            print("error: \(err)")
                        }
                    } catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                } else {
                    print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
                }
            }
            task.resume()
        } else {
            IndicatorViewer.hide()
            UIAlertController.showSystemAlert(title: "alert_no_connection".localized, message: "alert_no_connection_try".localized, buttons: ["place_ratting_vote_try_again".localized, "alert.default_login_close".localized]) { (index, buttonText) in
                if index == 0 {
                    self.dowloadFile(file: urlFile)
                }
            }
        }
    }
    
    // check file size
    // > 10mb return false else true
    static func checkFileSize(_ url: URL?) -> Bool {
        guard let filePath = url else {
            return false
        }
        
        do {
            let resources = try filePath.resourceValues(forKeys:[.fileSizeKey])
            if let fileSize = resources.fileSize, fileSize > 0 {
                let size = (Double(fileSize) / (1024 * 1024))
                print ("\(size)")
                return size >= 10 ? false : true
            }
            
            return true
        } catch {
            if Utils.isSandboxEnviroment {
                print("Error: \(error)")
            }
            return false
        }
    }
    
    static func readFileJson(_ nameFile: String) -> JSON? {
        let path = Bundle.main.bundleURL.appendingPathComponent(nameFile)
        let text = try? String(contentsOf: path)
        if text == nil { return nil }
        return JSON(parseJSON: text!)
    }
    
    static func showOfflineErrorDialog(handler: ((_ tapRetry: Bool) -> Void)? = nil) {
        if !APIUtilities.hasInternet {
            UIAlertController.showOfflineErrorAlert(completion: { index, isRetry in
                 handler?(index == 0)
            })
           
            return
        }
    }
    
    static func getAllIndexPathsInSection(section : Int, count: Int) -> [IndexPath] {
        return (0..<count).map { IndexPath(row: $0, section: section) }
    }
    
    static func showAlertRequiredUserLoggedIn(completion: @escaping ((Bool) -> Void)) {
        UIAlertController.showSystemAlert(title: "alert.default_title".localized,
                                          message: "alert.default_login".localized,
                                          buttons: ["alert.default_login_close".localized,
                                                    "alert.default_login_title".localized]) { (index, buttonText) in
            if index == 1 {
                
            }
        }
    }
    
    static func convertDate(date: String) -> String{
        let result = date.split(separator: "/")
        return "\(result[2])-\(result[1])-\(result[0])"
    }
    
    static func convertDate2(date: String) -> String{
        let result = date.split(separator: "/")
        return "\(result[2])-\(result[0])-\(result[1])"
    }
    
    static func removeUser() {
//        AccessToken.current = nil
//        Profile.current = nil
//        GIDSignIn.sharedInstance().signOut()
//        let fbLoginManager = LoginManager()
//        fbLoginManager.logOut()
        URLCache.shared.removeAllCachedResponses()
        if let urlFB = URL(string: "https://facebook.com/"),let coookfb = HTTPCookieStorage.shared.cookies(for: urlFB) {
            for cookie in coookfb {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        SharedData.emailUser = nil
        SharedData.accessToken = nil
        SharedData.freshToken = nil
        SharedData.avatarUser = nil
        SharedData.loginName = nil
        SharedData.accountId = nil
        SharedData.avatarUser = nil
        SharedData.setUserData(json: nil)
        SharedData.userID = nil
    }
    
    static func openOtherApp(scheme: String?, appstoreURL: String?, message: String?) {
        if let message = message, !message.isEmpty {
            UIAlertController.showQuickSystemAlert(title: nil, message: message)
            return
        }
        
        let urlScheme = URL(string: scheme ?? "")
        let urlStore = URL(string: appstoreURL ?? "")
        
        var urlApp: URL?
        if let urlScheme = urlScheme, UIApplication.shared.canOpenURL(urlScheme) {
            urlApp = urlScheme
        } else {
            urlApp = urlStore
        }
        if let urlApp = urlApp {
            UIApplication.shared.open(urlApp, options: [:], completionHandler: nil)
        }
    }
    
    static func callHotline(_ orPhone: String = ""){
        let numberCall = orPhone.isEmpty ? Constants.hotline : orPhone
        if let url = URL(string: "tel://" + numberCall) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // Function convert double to money
    static func convertDoubleToMoney(price: Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.string(from: NSNumber(value: price))
        formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
        if let balance = formatter.string(from: NSNumber(value: price)) {
            return balance
        }
        return "0"
    }
    
    static func calculateBMI(height: String?, weight: String?) -> Double? {
        calculateBMI(height: height?.double, weight: weight?.double)
    }
    
    static func calculateBMI(height: Double?, weight: Double?) -> Double? {
        guard var h = height, let w = weight else {
            return nil
        }
        if h.isZero || h.isNaN {
            return nil
        } else {
            h = h / 100
            let value = Int(w * 10 / (h * h))
            return Double(value) / 10
        }
    }
    
    static func setEnabledViews(isEnabled: Bool, views: UIView... ) {
        views.forEach{
            $0.alpha = isEnabled ? 1 : 0.5
            $0.isUserInteractionEnabled = isEnabled
        }
    }
    
    static func getStateBMI(_ bmi: Double) -> String {
        switch bmi {
        case 0..<18.5:
            return "Gầy"
        case 18.5..<23:
            return "Bình thường"
        case 23..<25:
            return "Thừa cân"
        case 25..<30:
            return "Béo phì độ I"
        case 30..<35:
            return "Béo phì độ II"
        default:
            return "Béo phì độ III"
        }
    }
    
    static func getAcedemic(_ qualification: String) -> String
    {
        switch qualification {
        case "Giáo sư":
            return "GS"
        case "Phó giáo sư":
            return "PGS"
        case "Không":
            return ""
        default:
            return ""
        }
    }
    
    static func getDoctorDegree(_ degreeType: String) -> String
    {
        switch degreeType {
        case "Thạc sĩ":
            return "ThS"
        case "Tiến sĩ":
            return "TS"
        case "Đại học":
            return ""
        default:
            return ""
        }
    }
    
    static func getQualification(_ acedemic: String) -> String
    {
        switch acedemic {
        case "Bác sĩ":
            return "BS"
        case "Bác sĩ CK I":
            return "BSCKI"
        case "Bác sĩ CK II":
            return "BSCKII"
        case "Bác sĩ nội trú":
            return "BSNT"
        default:
            return ""
        }
    }
    
    
}
