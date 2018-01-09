//
//  CameraViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Foundation

class CameraViewController: UIViewController {
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
    }
    
    private func layoutSetup() {
        
        setNavigationImage(#imageLiteral(resourceName: "logo"))
    }
}
