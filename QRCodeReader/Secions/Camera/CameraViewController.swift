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
import SafariServices
import JDStatusBarNotification

class CameraViewController: UIViewController {
    
    /// Success/Failure feedback
    let generator = UINotificationFeedbackGenerator()
    
    /// QR Code reader view
    lazy var qrReaderView: QRReaderView = QRReaderView()
    
    /// Empty view for camera permissions
    lazy var emptyView: EmptyView = EmptyView(title: "Please check your camera permissions in settings")
    
    /// Gallery image picker
    var imagePicker = UIImagePickerController()
    
    /// Camera roll button
    lazy var galleryButton: UIButton = { [unowned self] in
        
        let button = UIButton.button(style: .gradient)
        button.setImage(#imageLiteral(resourceName: "gallery"), for: .normal)
        button.setBackgroundColor(.white, forState: .normal)
        button.addTarget(self, action: #selector(onGallery(_:)), for: .touchUpInside)
        
        return button
        }()
    
    /// Flashlight button
    lazy var flashButton: UIButton = { [unowned self] in
        
        let button = UIButton.button(style: .gradient)
        button.setImage(#imageLiteral(resourceName: "flash"), for: .normal)
        button.setBackgroundColor(.white, forState: .normal)
        button.addTarget(self, action: #selector(onFlash(_:)), for: .touchUpInside)
        
        return button
        }()
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] response in
            DispatchQueue.main.sync {
                self.emptyViewLayout()
            }
        }
        
        /// Wake notification
        NotificationCenter.default.addObserver(self, selector: #selector(appDidWake), name: NSNotification.Name(rawValue: AppWakeNotificationKey), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        qrReaderView.startCapture()
    }
    
    @objc func appDidWake() {
        emptyViewLayout()
    }
    
    private func layoutSetup() {
        
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        view.backgroundColor = .black
        
        /// QR reader view layout
        view.addSubview(qrReaderView)
        qrReaderView.delegate = self
        qrReaderView.snp.makeConstraints { [unowned self] maker in
            maker.top.bottom.left.right.equalTo(self.view)
        }
        
        /// Flash button layout
        view.addSubview(flashButton)
        flashButton.snp.makeConstraints { [unowned self] maker in
            maker.bottom.equalTo(self.view).offset(-50)
            maker.centerX.equalTo(self.view)
            maker.width.height.equalTo(80)
        }
        
        //        /// Gallery button layout
        //        view.addSubview(galleryButton)
        //        galleryButton.snp.makeConstraints { [unowned self] maker in
        //            maker.bottom.equalTo(self.view).offset(-80)
        //            maker.centerX.equalTo(self.view).offset(60)
        //            maker.width.height.equalTo(80)
        //        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /// Layer updates
        flashButton.layer.cornerRadius = flashButton.frame.width / 2
        galleryButton.layer.cornerRadius = galleryButton.frame.width / 2
        
        flashButton.clipsToBounds = true
        galleryButton.clipsToBounds = true
    }
    
    // MARK: Actions
    @objc
    private func onGallery(_ sender: UIButton?) {
        showGallery()
    }
    
    @objc
    private func onFlash(_ sender: UIButton?) {
        qrReaderView.toggleFlash()
    }
    
    // MARK: Utilities
    private func showGallery() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.navigationBar.isTranslucent = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func emptyViewLayout() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            /// Empty view setup
            if !view.subviews.contains(emptyView) {
                view.addSubview(emptyView)
                emptyView.snp.makeConstraints { [unowned self] maker in
                    maker.top.bottom.left.right.equalTo(self.view)
                }
            }
        }
    }
    
    fileprivate func openLink(_ URL: URL) {
        
        let webController = WebViewController(url: URL)
        let webFlow = UINavigationController(rootViewController: webController)
        webFlow.navigationBar.isTranslucent = false
        
        webController.onClose { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
        
        present(webFlow, animated: true, completion: nil)
    }
    
    fileprivate func showError(_ error: Error) {
        
        generator.notificationOccurred(.error)
        JDStatusBarNotification.show(withStatus: error.localizedDescription, dismissAfter: 2.0, styleName: AppDefaultAlertStyle)
    }
}

// MARK: QRReader delegate
extension CameraViewController: QRReaderViewDelegate {
    
    /// Discovered output
    func qrReader(_ qrReader: QRReaderView, didOutput url: URL) {
        
        generator.notificationOccurred(.success)
        openLink(url)
    }
    
    func qrReader(_ qrReader: QRReaderView, failedToDetect error: Error) {
        showError(error)
    }
    
    func qrReader(_ qrReader: QRReaderView, failedToGetCamera error: Error) {
        showError(error)
    }
}

// MARK: ImagePickerController delegate
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true) { [unowned self] in
            
            /// Safety check
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage  else {
                return
            }
            
            self.qrReaderView.performQRCodeDetection(image: image)
        }
    }
}

