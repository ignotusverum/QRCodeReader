//
//  ViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
    /// Title
    func setTitle(_ titleText: String, color: UIColor = UIColor.black) {
        
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.type(type: .markPro, size: 24)
        
        label.sizeToFit()
        navigationItem.titleView = label
    }
    
    /// Add image to navigation controller
    func setNavigationImage(_ image: UIImage) {
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.black
        navigationItem.titleView = imageView
    }
}
