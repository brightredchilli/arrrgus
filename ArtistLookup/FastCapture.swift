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

let defaultError = NSError(domain: "", code: 0, userInfo: nil)

/// Class that quickly captures outputs of an AVCaptureSession
class IPFastCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    let captureSession = AVCaptureSession()

    override init() {
        output = AVCaptureVideoDataOutput()

        super.init()

        output.setSampleBufferDelegate(self, queue: outputDispatchQueue)

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
    }

    private func convertSampleBufferToImage(buffer: CMSampleBuffer) -> UIImage {
        return UIImage()
    }

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