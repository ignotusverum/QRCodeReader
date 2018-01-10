//
//  QRReaderView.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/10/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

enum QRReaderError: Error {
    
    case devideNotAvailable
    case inputNotAvailable
    
    func copy()-> String {
        switch self {
        case .devideNotAvailable:
            return "Whoops, please check your camera permissions in settings"
        case .inputNotAvailable:
            return "Whoops, please try again later"
        }
    }
}

protocol QRReaderViewDelegate {
    
    /// Failed to get current camera
    func qrReader(_ qrReader: QRReaderView, failedToGetCamera error: Error)
    
    /// Discovered output
    func qrReader(_ qrReader: QRReaderView, didOutput: [AVMetadataObject])
}

class QRReaderView: UIView {
    
    var delegate: QRReaderViewDelegate?
    
    /// Device configurations
    var device: AVCaptureDevice?
    
    /// QR session capture
    var qrCodeFrameView: UIView?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession = AVCaptureSession()
    
    /// QR Code types
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cameraSetup()
    }
    
    private func cameraSetup() {
       
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            delegate?.qrReader(self, failedToGetCamera: QRReaderError.devideNotAvailable)
            return
        }
        
        device = captureDevice
        
        do {
            
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            delegate?.qrReader(self, failedToGetCamera: QRReaderError.devideNotAvailable)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = layer.bounds
        layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        guard let qrCodeFrameView = qrCodeFrameView else {
            return
        }
        
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        addSubview(qrCodeFrameView)
        bringSubview(toFront: qrCodeFrameView)
    }
    
    func toggleFlash() {
        
        /// Tourch is not available
        guard let device = device, device.hasTorch == true else {
            return
        }
        
        /// Toggle harware torch
        do {
            try device.lockForConfiguration()
            device.torchMode = device.torchMode == .on ? .off : .on
        } catch {
            print("configuration issues")
        }
    }
}

extension QRReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            print("nothing is detected")
            qrCodeFrameView?.frame = .zero
            return
        }
        
        /// Discovered metadata objects
        delegate?.qrReader(self, didOutput: metadataObjects)
    }
}
