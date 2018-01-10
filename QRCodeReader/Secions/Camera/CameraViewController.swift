//
//  CameraViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    /// QR session capture
    var qrCodeFrameView:UIView?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    /// Camera roll button
    lazy var galleryButton: UIButton = {
       
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "camera-roll"), for: .normal)
        button.setBackgroundColor(.white, forState: .normal)
        button.addTarget(self, action: #selector(onGallery(_:)), for: .touchUpInside)
        
        return button
    }()
    
    /// Flashlight button
    lazy var flashButton: UIButton = {
       
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "flash"), for: .normal)
        button.setBackgroundColor(.white, forState: .normal)
        button.addTarget(self, action: #selector(onFlash(_:)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        cameraSetup()
    }
    
    private func layoutSetup() {
     
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        view.backgroundColor = .black
        
        /// Flash button layout
        view.addSubview(flashButton)
        flashButton.snp.makeConstraints { [unowned self] maker in
            maker.bottom.equalTo(self.view).offset(-80)
            maker.left.equalTo(self.view).offset(70)
            maker.width.height.equalTo(80)
        }
        
        /// Gallery button layout
        view.addSubview(galleryButton)
        galleryButton.snp.makeConstraints { [unowned self] maker in
            maker.bottom.equalTo(self.view).offset(-80)
            maker.right.equalTo(self.view).offset(-70)
            maker.width.height.equalTo(80)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /// Layer updates
        galleryButton.layer.cornerRadius = galleryButton.frame.width / 2
        galleryButton.clipsToBounds = true
        
        flashButton.layer.cornerRadius = flashButton.frame.width / 2
        flashButton.clipsToBounds = true
    }
    
    // MARK: Utilities
    @objc
    private func onGallery(_ sender: UIButton?) {
        print("gallery")
    }
    
    @objc
    private func onFlash(_ sender: UIButton?) {
        print("flash")
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
