//
//  SignOutCollectionViewCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/17/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

class SignOutCell: UICollectionViewCell {
    
    /// Sign out button
    lazy var signOutButton: UIButton = {
        
        let button = UIButton(frame: .zero)
        button.setTitle("SIGN OUT", for: .normal)
        button.setTitleColor(UIColor.defaultRed, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Sign out button
        addSubview(signOutButton)
        
        signOutButton.layer.borderWidth = 2
        signOutButton.layer.cornerRadius = 8
        signOutButton.layer.borderColor = UIColor.defaultRed.cgColor
        
        /// Sign out button layout
        signOutButton.snp.updateConstraints { maker in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(self)
            maker.centerY.equalTo(self)
        }
    }
}
