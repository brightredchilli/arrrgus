//
//  ImageRecognizer.swift
//  ArtistLookup
//
//  Created by Ying Quan Tan on 8/14/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import Foundation

class ImageRecognizer: NSObject, IPFastCaptureDelegate {

    let tesseract: G8Tesseract

    override init() {
        tesseract = G8Tesseract(language: "eng")
        tesseract.maximumRecognitionTime = 1

        tesseract.setVariableValue("false", forKey: kG8ParamLoadFreqDawg)
        tesseract.setVariableValue("false", forKey: kG8ParamLoadSystemDawg)

        super.init()
    }

    // MARK: IPFastCaptureDelegate

    func fastCaptureDidCaptureImage(image: UIImage) {
        // this is testing code, this will probably block this captureoutput thread
        tesseract.image = image;
        tesseract.rect = CGRectMake(0, 0, image.size.width, 700)
        let success = tesseract.recognize()
        print("success? = \(success) language(\(tesseract.language)) recognizedText = \(tesseract.recognizedText)")
//        print("symbols = \(tesseract.recognizedBlocksByIteratorLevel(G8PageIteratorLevel.Symbol))")
    }
}