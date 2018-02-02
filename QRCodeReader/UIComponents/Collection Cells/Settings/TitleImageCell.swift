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
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var image: UIImage? {
        didSet {
            iconImageView.image = image
        }
    }
    
    private var titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.type(type: .markPro)
        
        return label
    }()
    
    var iconImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Image layout
        addSubview(iconImageView)
        iconImageView.snp.updateConstraints { maker in
            maker.left.equalTo(20)
            maker.width.height.equalTo(18)
            maker.centerY.equalToSuperview()
        }
        
        /// Title layout
        addSubview(titleLabel)
        titleLabel.snp.updateConstraints { [unowned self] maker in
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
            maker.left.equalTo(iconImageView.snp.right).offset(20)
            maker.right.equalTo(self).offset(-20)
        }
    }
    
    func setupTitle(_ title: String, iconImage: UIImage = UIImage()) {

        titleLabel.text = title.capitalizeFirst()
        titleLabel.sizeToFit()
        
        iconImageView.image = iconImage
    }
}
