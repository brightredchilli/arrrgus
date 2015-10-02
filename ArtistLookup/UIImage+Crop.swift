//
//  UIImage+Crop.swift
//  ArtistLookup
//
//  Created by Ying Quan Tan on 9/4/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import Foundation

private func degreesToRadians(degrees : Double) -> Double {
    return degrees * M_PI/180.0
}

extension UIImage {
    func cropImageToRect(rect: CGRect) -> UIImage {
        let imageRef = CGImageCreateWithImageInRect(CGImage, rect);
        let bitmapInfo = CGImageGetBitmapInfo(imageRef)
        let colorSpace = CGImageGetColorSpace(imageRef)
        let bitmap = CGBitmapContextCreate(nil, Int(rect.width), Int(rect.height), CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpace, bitmapInfo.rawValue)

        if imageOrientation == .Left {
            CGContextRotateCTM(bitmap, CGFloat(degreesToRadians(90)))
            CGContextTranslateCTM(bitmap, 0, -rect.height)
        } else if imageOrientation == .Right {
            CGContextRotateCTM(bitmap, CGFloat(degreesToRadians(-90)))
            CGContextTranslateCTM(bitmap, -rect.width, 0)
        } else if imageOrientation == .Up {
            // NOTHING
        } else if imageOrientation == .Down {
            CGContextTranslateCTM(bitmap, rect.width, rect.height)
            CGContextRotateCTM(bitmap, CGFloat(degreesToRadians(-180)))
        }

        CGContextDrawImage(bitmap, CGRectMake(0, 0, rect.width, rect.height), imageRef)
        let ref = CGBitmapContextCreateImage(bitmap)
        return UIImage(CGImage: ref!)
    }

    func resizeImageWithAspectFill(targetSize: CGSize) -> UIImage {
        let scaleRatio = targetSize.width/self.size.width
        let targetRect = CGRectMake(0, 0, floor(self.size.width * scaleRatio), floor(self.size.height * scaleRatio))
        UIGraphicsBeginImageContextWithOptions(targetSize, true, 1)
        self.drawInRect(targetRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func writeToDocumentsWithName(filename: String) {
        UIImagePNGRepresentation(self)?.writeToFile(documentsPathForFileName(filename), atomically: false)
    }

    private func documentsPathForFileName(fileName: String) -> String {
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let writePath = NSURL(string: documents)?.URLByAppendingPathComponent(fileName)
        return writePath!.absoluteString
    }
}


func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSizeMake(lhs.width * rhs, lhs.height * rhs)
}
