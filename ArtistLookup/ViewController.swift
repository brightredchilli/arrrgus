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

    let targetImageSize = CGSizeMake(1080, 1920)
    let croppedSize = CGSizeMake(1000, 400)

    var capture: IPFastCapture?
    let recognizer = ImageRecognizer()
    var hasSetup = false

    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet var previewView: UIView!
    var debugView: UIView?

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
    }

    override func viewDidLayoutSubviews() {
        // do this in here so that previewView has proper size by then
        setUpPreviewViewIfNecessary()
    }

    func fastCaptureDidCaptureImage(image: UIImage) {
        let resizedImage = image.resizeImageWithAspectFill(targetImageSize)
        let croppedImage = resizedImage.cropImageToRect(CGRect(center: targetImageSize.center(),
                                                        width: croppedSize.width,
                                                        height: croppedSize.height))
        var text : String! = nil;
        let recognitionTime = executionTimeInterval {
            text = self.recognizer.recognizeImage(croppedImage)
        }
        print("recognition time = \(recognitionTime)")

        outputLabel.text = text
    }

    func setUpPreviewViewIfNecessary() {
        if !hasSetup {
            hasSetup = true
            addPreviewLayer()
            setUpDebugView()
        }
    }

    func addPreviewLayer() {
        let layer = AVCaptureVideoPreviewLayer(session: capture?.captureSession)
        layer.frame = previewView.bounds
        previewView.layer.insertSublayer(layer, atIndex: 0)
    }

    func setUpDebugView() {
        let ratio = previewView.frame.width/targetImageSize.width
        debugView?.removeFromSuperview()

        debugView = {
            let debugView = UIView()
            previewView.addSubview(debugView)
            debugView.autoAlignAxisToSuperviewAxis(.Horizontal)
            debugView.autoAlignAxisToSuperviewAxis(.Vertical)
            debugView.autoSetDimensionsToSize(croppedSize * ratio)
            debugView.layer.borderColor = UIColor.redColor().CGColor
            debugView.layer.borderWidth = 1;
            return debugView
            }()
    }
}


