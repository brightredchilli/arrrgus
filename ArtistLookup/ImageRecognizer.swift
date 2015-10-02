//
//  ImageRecognizer.swift
//  ArtistLookup
//
//  Created by Ying Quan Tan on 8/14/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import Foundation

class ImageRecognizer: NSObject {

    let tesseract: G8Tesseract

    override init() {
        tesseract = G8Tesseract(language: "eng")
        tesseract.maximumRecognitionTime = 1

        tesseract.setVariableValue("false", forKey: kG8ParamLoadFreqDawg)
        tesseract.setVariableValue("false", forKey: kG8ParamLoadSystemDawg)

        super.init()
    }

    func recognizeImage(image: UIImage) -> String? {
        // this is testing code, this will probably block this captureoutput thread
        tesseract.image = image;
        let success = tesseract.recognize()
        print("success? = \(success) language(\(tesseract.language)) recognizedText = \(tesseract.recognizedText)")

        return success ? tesseract.recognizedText : nil
    }

}