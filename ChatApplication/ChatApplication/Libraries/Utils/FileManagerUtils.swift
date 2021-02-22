//
//  FileManagerUtils.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 2/19/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

class FileManagerUtils {
    
    // MARK: - Static variables
    static let fileManager: FileManager  = FileManager.default
    static let directoryTemp = "TEMP_FOLDER"
    static let avatarFileName = "avatar.png"
    static var documentDirectoryUrl: URL {
        return FileManagerUtils.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static var cachesDirectory: URL {
        return FileManagerUtils.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
      
    // MARK: - Static functions
    @discardableResult
    static func saveFileWith(data: Data, name: String, atUrl url: URL = FileManagerUtils.documentDirectoryUrl) -> URL? {
        let filePath = url.appendingPathComponent("\(name)")
        do {
            try data.write(to: filePath, options: .atomic)
            return filePath
        } catch { }
        return nil
    }
    
    @discardableResult
    static func removeFileAt(url: URL) -> Bool {
        do {
            try FileManagerUtils.fileManager.removeItem(at: url)
            return true
        } catch { }
        return false
    }
    
    static func createFile(fileName: String, data: Data? = nil) -> URL? {
        let url = documentDirectoryUrl.appendingPathComponent(fileName)
        if let data = data {
            do {
                try data.write(to: url)
                return url
            } catch _ {
                return nil
            }
        }
        return url
    }
    
    static func createCacheFile(fileName: String, data: Data? = nil) -> URL? {
        let url = cachesDirectory.appendingPathComponent(fileName)
        if let data = data {
            do {
                try data.write(to: url)
                return url
            } catch _ {
                return nil
            }
        }
        return url
    }
    
    static func createFileTemp(fileName: String, data: Data? = nil) -> URL? {
        let directory = cachesDirectory.appendingPathComponent(directoryTemp)
        let url = directory.appendingPathComponent(String(Date().millis) + "_\(fileName)")
        do {
            if !directory.isExsist() {
                try FileManagerUtils.fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }
            if let data = data {
                try data.write(to: url)
            }
        }catch _ {
            return nil
        }
        return url
    }
    
    static func removeFile(url: URL) -> Bool {
        do {
            try fileManager.removeItem(at: url)
            return true
        }catch _ {
            
        }
        return false
    }
    
    static func removeFileTemp() -> Bool {
        return removeFile(url: cachesDirectory.appendingPathComponent(directoryTemp))
    }
    
}
