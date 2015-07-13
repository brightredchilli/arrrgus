//
//  FastCapture.swift
//  ArtistLookup
//
//  Created by Ying Quan Tan on 7/10/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreGraphics

let defaultError = NSError(domain: "", code: 0, userInfo: nil)

/// Class that quickly captures outputs of an AVCaptureSession
class IPFastCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, G8TesseractDelegate {

    let captureSession = AVCaptureSession()
    let tesseract: G8Tesseract

    override init() {
        output = AVCaptureVideoDataOutput()
        tesseract = G8Tesseract(language: "eng")

        super.init()

        output.setSampleBufferDelegate(self, queue: outputDispatchQueue)
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey  : NSNumber(int: Int32(kCVPixelFormatType_32BGRA.value))]




        queue.addOperationWithBlock { [unowned self] Void in
            do { try self.setUpCaptureSession() }
            catch {

            }
        }
        
    }

    private func setUpCaptureSession() throws {

        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        guard device != nil else { throw defaultError }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            } else {
                defaultError
            }

            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
            } else {
                throw defaultError
            }
        } catch {
            throw error
        }

        captureSession.startRunning()
    }

    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate Methods

    func captureOutput(captureOutput: AVCaptureOutput!,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
        fromConnection connection: AVCaptureConnection!) {
            if let buffer = sampleBuffer {
                let image = convertSampleBufferToImage(buffer)

            }
    }
    //https://github.com/gali8/Tesseract-OCR-iOS/wiki/Installation

    //http://stackoverflow.com/questions/3152259/how-to-convert-a-cvimagebufferref-to-uiimage
    private func convertSampleBufferToImage(sampleBuffer: CMSampleBuffer) -> UIImage {

        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            CVPixelBufferLockBaseAddress(imageBuffer, 0)

            let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
            let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
            let width = CVPixelBufferGetWidth(imageBuffer)
            let height = CVPixelBufferGetWidth(imageBuffer)

            CVPixelBufferUnlockBaseAddress(imageBuffer, 0)

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let newContext = CGBitmapContextCreate(baseAddress,
                width,
                height,
                8,
                bytesPerRow,
                colorSpace,
                CGBitmapInfo.ByteOrder32Little.rawValue)

            let newImage = CGBitmapContextCreateImage(newContext)
            let image = UIImage(CGImage: newImage!, scale: 1, orientation: .Right)
            return image
        }
        return UIImage()
    }

    // MARK: G8TesseractDelegate


    private let output: AVCaptureVideoDataOutput

    private let queue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
        }()

    private let outputDispatchQueue: dispatch_queue_t = {
        let attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0)
        let queue = dispatch_queue_create("com.intrepid.FastCapture", attr)
        return queue
    }()




}