//
//  UIImage+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

extension UIImage {
    // MARK: - Variables
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - Init
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    convenience init?(_ nameString: String?) {
        if let name = nameString {
            self.init(named: name)
        } else {
            return nil
        }
    }
    
    // MARK: - Static functions
    static func getVideoThumbnailFor(url : URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMake(value: 1, timescale: 60)
        let img: CGImage
        do {
            try img = assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg: UIImage = UIImage(cgImage: img)
            return frameImg
        } catch { }
        return nil
    }
    
    func filledImage(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        fillColor.setFill()
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setBlendMode(CGBlendMode.colorBurn)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.draw(self.cgImage!, in: rect)
        
        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return coloredImg
    }
    
    func resizeTo(width: CGFloat) -> UIImage? {
        let image = self
        let scale = width / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeTo(size: CGFloat) -> UIImage? {
        let sizeImage = CGSize(width: size, height: size)
        return UIGraphicsImageRenderer(size: sizeImage).image { _ in
            self.draw(in: CGRect(origin: .zero, size: sizeImage))
        }
    }
    
    var roundedImage: UIImage {
        let originalSize = self.size
        let originalWidth = originalSize.width
        let originalHeight = originalSize.height
        let radius = originalWidth > originalHeight ? originalWidth/2.0 : originalHeight/2.0
        let size = CGSize.init(width: min(originalWidth, originalHeight), height: min(originalWidth, originalHeight))
        
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: radius
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    var cropToCenterSquare: UIImage? {
        guard let cgimage = self.cgImage else { return nil }
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(self.size.width)
        var cgheight: CGFloat = CGFloat(self.size.height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        return image
    }
    
    func maskRoundedImage( radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: self)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
    
    func saveToDocuments(filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
    
    func resizeTo(percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizeTo(mb: Int) -> UIImage? {
        guard let imageData = pngData() else { return nil }
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1024.0 // ! Or devide for 1024 if you need KB but not kB
        while imageSizeKB > 1024.0 * Double(mb) { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resizeTo(percentage: 0.9),
                let imageData = resizedImage.pngData()
                else { return nil }
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        return resizingImage
    }    
    
    func scalingAndCroppingFor(size: CGSize) -> UIImage? {
        let sourceImage = self
        var newImage: UIImage? = nil
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = size.width
        let targetHeight = size.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        if !imageSize.equalTo(size) {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor { scaleFactor = widthFactor }
            else { scaleFactor = heightFactor }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        UIGraphicsBeginImageContext(size) // this will crop
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        //pop the context to get back to the default
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func rotateBy(degrees: CGFloat) -> UIImage {
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func renderOriginal() -> UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    func renderTemplate() -> UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
}
