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
    
    case invalidLink
    case noQRDetected
    case inputNotAvailable
    case devideNotAvailable
}

extension QRReaderError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .inputNotAvailable:
            return "Whoops, please try again later"
        case .invalidLink:
            return "Whoops, looks like this link is invalid"
        case .devideNotAvailable:
            return "Whoops, please check your camera permissions in settings"
        case .noQRDetected:
            return "Whoops, we were unable to detect any qr code in that image"
        }
    }
}

protocol QRReaderViewDelegate {
    
    /// Discovered output
    func qrReader(_ qrReader: QRReaderView, didOutput url: URL)
    
    /// Failed to detect code
    func qrReader(_ qrReader: QRReaderView, failedToDetect error: Error)
    
    /// Failed to get current camera
    func qrReader(_ qrReader: QRReaderView, failedToGetCamera error: Error)
    
    /// Discovered Event ID
    func qrReader(_ qrReader: QRReaderView, didOutput orderItemGUID: String)
    
    /// QRReader flash
    func qrReader(_ qrReader: QRReaderView, flashOptionChanged: AVCaptureDevice.TorchMode)
}

class QRReaderView: UIView {
    
    var delegate: QRReaderViewDelegate?
    
    /// Device configurations
    private var device: AVCaptureDevice?
    
    /// Should show error
    /// Checks if previous validation was successfull
    var isNeedToShowError: Bool = true
    
    /// QR session capture
    private var qrCodeFrameView: UIView?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var captureSession: AVCaptureSession = AVCaptureSession()
    
    /// QR Code types
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    // MARK: Initialization
    init() {
        super.init(frame: .zero)
        
        cameraSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Preview layout
        videoPreviewLayer?.frame = layer.bounds
    }
    
    // MARK: Setup
    private func cameraSetup() {
       
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
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
            if captureSession.inputs.isEmpty {
                captureSession.addInput(input)
            }
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            if captureSession.outputs.isEmpty {
                captureSession.addOutput(captureMetadataOutput)
            }
            
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
    
    // MARK: Utilities
    fileprivate func parseOrderItemGUID(_ string: String)-> String? {
        if let range = string.range(of: "check_in/") {
            return String(string[range.upperBound...])
        }
        
        return nil
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
            delegate?.qrReader(self, flashOptionChanged: device.torchMode)
        } catch {
            print("configuration issues")
        }
    }
    
    func performQRCodeDetection(image: UIImage) {
        
        /// Transform
        guard let ciImage = CIImage(image: image) else {
            
            /// Error handler
            delegate?.qrReader(self, failedToDetect: QRReaderError.noQRDetected)
            
            return
        }
        
        /// Get qr code from image
        var result: String?
        let detector = prepareQRCodeDetector()
        let features = detector.features(in: ciImage)
        for feature in features as! [CIQRCodeFeature] {
            result = feature.messageString
        }
        
        /// Detection handler
        guard let resultString = result else {
            delegate?.qrReader(self, failedToDetect: QRReaderError.noQRDetected)
            return
        }
        
        guard let url = URL(string: resultString) else {
            delegate?.qrReader(self, failedToDetect: QRReaderError.invalidLink)
            return
        }
        
        delegate?.qrReader(self, didOutput: url)
    }
    
    func startCapture() {
        captureSession.startRunning()
        qrCodeFrameView?.frame = .zero
    }
    
    private func prepareQRCodeDetector() -> CIDetector {
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        return CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)!
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
        
        // Get the metadata object.
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            
            if isNeedToShowError {
                delegate?.qrReader(self, failedToDetect: QRReaderError.invalidLink)
            }
            
            isNeedToShowError = false
            
            return
        }
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            guard let metadataString = metadataObj.stringValue else {
                
                if isNeedToShowError {
                    delegate?.qrReader(self, failedToDetect: QRReaderError.noQRDetected)
                }
                
                isNeedToShowError = false
                return
            }
            
            /// Check if url is valid
            guard let url = URL(string: metadataString), UIApplication.shared.canOpenURL(url) else {
                
                if isNeedToShowError {
                    delegate?.qrReader(self, failedToDetect: QRReaderError.invalidLink)
                }
                
                isNeedToShowError = false
                return
            }
            
            /// Check if need to handle or or Event ID
            let config = Config.shared
            
            if config.qrWebEnabled {
                delegate?.qrReader(self, didOutput: url)
            } else if let eventID = parseOrderItemGUID(metadataString) {
                delegate?.qrReader(self, didOutput: eventID)
            }
            
            /// Stop
            captureSession.stopRunning()
            
            isNeedToShowError = true
        }
    }
}
