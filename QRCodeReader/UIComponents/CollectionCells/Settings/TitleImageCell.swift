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

class TitleImageCell: UICollectionViewCell {
    
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
            maker.top.left.equalTo(20)
            maker.width.height.equalTo(30)
        }
        
        /// Title layout
        addSubview(titleLabel)
        titleLabel.snp.updateConstraints { [unowned self] maker in
            maker.top.bottom.equalTo(self)
            maker.left.equalTo(iconImageView.snp.right).offset(20)
            maker.right.equalTo(self).offset(-20)
        }
    }
    
    func setupTitle(_ title: String, iconImage: UIImage) {

        titleLabel.text = title
        titleLabel.sizeToFit()
        
        iconImageView.image = iconImage
    }
}
