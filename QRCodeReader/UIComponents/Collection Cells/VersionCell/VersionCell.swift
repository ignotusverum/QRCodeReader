//
//  VersionCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/29/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

class VersionCell: UICollectionViewCell {
    
    /// Title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.type(type: .markPro)
        label.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        
        return label
    }()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// title label
        addSubview(titleLabel)
        let appVersion = Bundle.main.versionNumber ?? ""
        let bundleVersion = Bundle.main.buildNumber ?? ""
        titleLabel.text = "v \(appVersion) (\(bundleVersion))"
        
        /// title label layout
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
    }
}

