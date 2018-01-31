//
//  TitleCellProtocol.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/29/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

protocol TitleCellProtocol {
    
    /// Text
    var text: String! { get set }
    
    /// Text color
    var textColor: UIColor { get }
    
    /// Title label
    var titleLabel: UILabel { get set }
}

extension TitleCellProtocol {
    var textColor: UIColor {
        return UIColor.black
    }
}

extension TitleCellProtocol where Self: UICollectionViewCell {
    
    func generateTitleLabel()-> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.type(type: .markPro, size: 17)
        
        label.textAlignment = .left
        return label
    }
    
    func titleLayout() {
        
        /// Title label
        addSubview(titleLabel)
        titleLabel.textColor = textColor
        
        /// Title label layout
        titleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-25)
            maker.height.equalTo(self)
            maker.top.equalTo(self)
        }
    }
}

