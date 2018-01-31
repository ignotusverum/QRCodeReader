//
//  TitleImageCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class TitleImageCell: UICollectionViewCell, AccessoryCellProtocol {
    
    lazy var accessoryImageView: UIImageView = self.generateAccessoryImage()
    
    private var titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.type(type: .markPro)
        
        return label
    }()
    
    private var iconImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Image layout
        addSubview(iconImageView)
        iconImageView.snp.updateConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(20)
            maker.width.height.equalTo(30)
        }
        
        /// Title layout
        addSubview(titleLabel)
        titleLabel.snp.updateConstraints { [unowned self] maker in
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
            maker.left.equalTo(iconImageView.snp.right).offset(20)
            maker.right.equalTo(self).offset(-20)
        }
        
        /// Accessory image
        accessoryLayout()
    }
    
    func setupTitle(_ title: String, iconImage: UIImage = UIImage()) {

        titleLabel.text = title.capitalizeFirst()
        titleLabel.sizeToFit()
        
        iconImageView.image = iconImage
    }
}
