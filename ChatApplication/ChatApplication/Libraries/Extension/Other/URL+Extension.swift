//
//  URL+Extension.swift
//  E-Office
//
//  Created by manhnv on 4/15/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
import MobileCoreServices

extension URL {
    
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
    
    func size() -> String {
        do {
            let fileAttribute: [FileAttributeKey : Any] = try FileManager.default.attributesOfItem(atPath: self.path)
            
            if let fileNumberSize: NSNumber = fileAttribute[FileAttributeKey.size] as? NSNumber {
                let fileSizeValue = UInt64(truncating: fileNumberSize)
                
                let byteCountFormatter: ByteCountFormatter = ByteCountFormatter()
                byteCountFormatter.countStyle = ByteCountFormatter.CountStyle.file
                byteCountFormatter.allowedUnits = [.useAll]
                byteCountFormatter.isAdaptive = false
                return byteCountFormatter.string(fromByteCount: Int64(fileSizeValue))
            }
            return ""
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    func createAtDate() -> String {
        
        do {
            let fileAttribute: [FileAttributeKey : Any] = try FileManager.default.attributesOfItem(atPath: self.path)
            
            if let fileCreateAt: Date = fileAttribute[FileAttributeKey.creationDate] as? Date {
           
                return fileCreateAt.toString(format: "dd-MM-yyyy")
            }
            return Date().toString(format: "dd-MM-yyyy")
        } catch {
            print(error.localizedDescription)
            return Date().toString(format: "dd-MM-yyyy")
        }
        
    }
    
    func isExsist() -> Bool {
        return FileManagerUtils.fileManager.fileExists(atPath: path)
    }
    
    func removeFile() -> Bool {
        return FileManagerUtils.removeFile(url: self)
    }
}
