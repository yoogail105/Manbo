//
//  CameraViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    static let identifier = "CameraViewController"
 
    var captureSession: AVCaptureSession!
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backCameraInput: AVCaptureInput!
    var frontCameraInput: AVCaptureInput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoOutput: AVCaptureVideoDataOutput!

    var takePicture = false
    var isBackCamera = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
    }

}



