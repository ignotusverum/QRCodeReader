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

class CameraViewController: UIViewController {
    
    /// QR Code reader view
    lazy var qrReaderView: QRReaderView = QRReaderView()
    
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
    }
    
    private func layoutSetup() {
     
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        view.backgroundColor = .black
        
        /// QR reader view layout
        view.addSubview(qrReaderView)
        qrReaderView.snp.makeConstraints { [unowned self] maker in
            maker.top.bottom.left.right.equalTo(self.view)
        }
        
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
        galleryButton.layer.borderWidth = 1
        galleryButton.layer.borderColor = UIColor.blue.cgColor
        
        flashButton.layer.cornerRadius = flashButton.frame.width / 2
        
        flashButton.clipsToBounds = true
        flashButton.layer.borderWidth = 1
        flashButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    // MARK: Utilities
    @objc
    private func onGallery(_ sender: UIButton?) {
        print("gallery")
    }
    
    @objc
    private func onFlash(_ sender: UIButton?) {
        qrReaderView.toggleFlash()
    }
}
