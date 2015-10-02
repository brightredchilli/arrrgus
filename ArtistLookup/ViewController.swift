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

class ViewController: UIViewController, IPFastCaptureDelegate {

    var capture: IPFastCapture?
    let recognizer = ImageRecognizer()
    @IBOutlet var imageView: UIImageView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        capture = IPFastCapture()
        capture?.delegate = self

//        self.addPreviewLayer()
//        recognizer.fastCaptureDidCaptureImage(UIImage(named:"naturebox")!)
//        recognizer.fastCaptureDidCaptureImage(UIImage(named:"lightning")!)
//        recognizer.fastCaptureDidCaptureImage(UIImage(named:"three_body")!)

        let updatedFrame = view.frame.scaledRectWithScale(0, yScale: 0.3, widthScale: 1, heightScale: 0.3)

        let debugView  = UIView()
        imageView.addSubview(debugView)

    }

    func fastCaptureDidCaptureImage(image: UIImage) {
        imageView.image = image
        recognizer.fastCaptureDidCaptureImage(image)

    }

    func addPreviewLayer() {
        let layer = AVCaptureVideoPreviewLayer(session: capture?.captureSession)
        layer.frame = self.view.bounds
        self.view.layer.addSublayer(layer)
    }
}


