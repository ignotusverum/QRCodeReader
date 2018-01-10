//
//  CameraViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    /// QR session capture
    var qrCodeFrameView:UIView?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    /// Camera roll button
    lazy var rightButton: UIBarButtonItem = {
       
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "camera-roll"), style: .plain, target: self, action: #selector(onRightButton(_:)))
        button.tintColor = .black
        return button
    }()
    
    /// Flashlight button
    lazy var leftButton: UIBarButtonItem = {
    
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "flash"), style: .plain, target: self, action: #selector(onLeftButton(_:)))
        button.tintColor = .black
        return button
    }()
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        cameraSetup()
    }
    
    private func layoutSetup() {
     
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        view.backgroundColor = .white
    }
    
    // MARK: Utilities
    @objc
    private func onRightButton(_ sender: Any?) {
        print("right")
    }
    
    @objc
    private func onLeftButton(_ sender: Any?) {
        print("left")
    }
    
    private func cameraSetup() {
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Start video capture.
        captureSession?.startRunning()
    }
}
