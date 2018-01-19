//
//  AccessoryCellProtocol.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/18/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

protocol AccessoryCellProtocol {
    
    /// Accessory image
    var accessoryImageView: UIImageView { get set }
}

extension AccessoryCellProtocol where Self: UICollectionViewCell {
    
    /// Accessory image
    func generateAccessoryImage()-> UIImageView {
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "forward"))
        
        return imageView
    }
    
    /// Setup divider layout
    func accessoryLayout() {
        
        /// Accessory
        addSubview(accessoryImageView)
        
        /// accessory view
        accessoryImageView.snp.updateConstraints { maker in
            maker.right.equalTo(self).offset(-25)
            maker.height.equalTo(13)
            maker.width.equalTo(8)
            maker.centerY.equalTo(self)
        }
    }
}


