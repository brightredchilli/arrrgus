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

protocol IPFastCaptureDelegate {
    func fastCaptureDidCaptureImage(image: UIImage)
}

func executionTimeInterval(block: () -> ()) -> CFTimeInterval {
    let start = CACurrentMediaTime()
    block();
    let end = CACurrentMediaTime()
    return end - start
}

/// Class that quickly captures outputs of an AVCaptureSession
class IPFastCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, G8TesseractDelegate {

    let captureSession = AVCaptureSession()
    var delegate: IPFastCaptureDelegate?

    override init() {
        output = AVCaptureVideoDataOutput()

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
            print("captureOutput:")
            if let buffer = sampleBuffer {
                var image : UIImage! = nil;
                let convertSampleBufferTimeInterval = executionTimeInterval({
                    image = self.convertSampleBufferToImage(buffer);
                })
                print("convertSampleBufferToImage: \(convertSampleBufferTimeInterval)")
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in

                    self.delegate?.fastCaptureDidCaptureImage(image)
                })
            }
    }
    //https://github.com/gali8/Tesseract-OCR-iOS/wiki/Installation

    //http://stackoverflow.com/questions/3152259/how-to-convert-a-cvimagebufferref-to-uiimage
    private func convertSampleBufferToImage(sampleBuffer: CMSampleBuffer) -> UIImage {

        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return UIImage() }

        CVPixelBufferLockBaseAddress(imageBuffer, 0)

        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)

        CVPixelBufferUnlockBaseAddress(imageBuffer, 0)

        var info: UInt32 = CGImageAlphaInfo.PremultipliedFirst.rawValue
        let little: UInt32 = CGBitmapInfo.ByteOrder32Little.rawValue
        info = info | little

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newContext = CGBitmapContextCreate(baseAddress,
            width,
            height,
            8,
            bytesPerRow,
            colorSpace,
            info)

        let newImage = CGBitmapContextCreateImage(newContext)
        let image = UIImage(CGImage: newImage!, scale: 1, orientation: .Right)
        return image
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