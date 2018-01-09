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

class CameraViewController: UIViewController {
    
    /// QR session capture
    var captureSession: AVCaptureSession?
    
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
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                } else {
                    //access denied
                }
            })
        }
        
        layoutSetup()
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
}
