//
//  TestRecognizer.swift
//  ArtistLookup
//
//  Created by Ying Quan Tan on 9/25/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import Foundation
import ImageIO

class TestCode {
    class func test() {
        var image = UIImage(named:"ray")!
        image = image.resizeImageWithAspectFill(CGSizeMake(1146, 1536))
        image.writeToDocumentsWithName("test.png")

        let centerRect = CGRect(center: CGPointMake(image.size.width/2, image.size.height/2), width: 900, height: 400)
        let croppedImage = image.cropImageToRect(centerRect)
        croppedImage.writeToDocumentsWithName("test-cropped.png")

        let recognizer = ImageRecognizer()
        recognizer.recognizeImage(image)
    }
}

extension CGRect {
    init(center: CGPoint, width: CGFloat, height: CGFloat) {
        origin = CGPointMake(center.x - width/2, center.y - height/2)
        size = CGSizeMake(width, height)
    }

    func scaledRectWithScale(xScale: CGFloat, yScale: CGFloat, widthScale: CGFloat, heightScale: CGFloat) -> CGRect {
        return CGRectMake(origin.x + xScale*size.width,
            origin.y + yScale*size.height,
            size.width * widthScale,
            size.height * heightScale)
    }
}