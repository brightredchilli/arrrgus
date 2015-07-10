//
//  FastCapture.swift
//  ArtistLookup
//
//  Created by Ying Quan Tan on 7/10/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import Foundation
import AVFoundation

/// Class that quickly captures outputs of an AVCaptureSession
class IPFastCapture {

    let captureSession = AVCaptureSession()

    init() {
        queue.addOperationWithBlock { [unowned self] Void in
            do { try self.setUpCaptureSession() }
            catch {

            }
        }
        
    }

    private func setUpCaptureSession() throws {

        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        guard device != nil else { throw NSError(domain: "", code: 0, userInfo: nil) }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch {
            throw error
        }
        captureSession.startRunning()
    }

    private let queue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
        }()



}