//
//  ViewController.swift
//  ArtistLookup
//
//  Created by Ying Quan Tan on 7/10/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import UIKit
import AVFoundation

func dispatch_on_main_queue_after(when: dispatch_time_t, block: dispatch_block_t) {
    dispatch_after(2, dispatch_get_main_queue(), {
        block()
    })
}

class ViewController: UIViewController {

    let capture = IPFastCapture()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addPreviewLayer()
    }

    func addPreviewLayer() {
        let layer = AVCaptureVideoPreviewLayer(session: self.capture.captureSession)
        layer.frame = self.view.bounds
        self.view.layer.addSublayer(layer)
    }
}

