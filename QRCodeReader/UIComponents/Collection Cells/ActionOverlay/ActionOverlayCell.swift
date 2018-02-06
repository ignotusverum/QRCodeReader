//
//  ActionOverlayCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/29/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

class ActionOverlayCell: UICollectionViewCell {
    
    var action: OverlayAction!
    
    var actionButton: UIButton = {
        
        let button = UIButton()
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonSetup()
        
        addSubview(actionButton)
        actionButton.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.bottom.equalTo(-5)
        }
    }
    
    func buttonSetup () {
        actionButton.setTitle(action.title, for: .normal)
        
        if action.style == .button {
            actionButton.addGradientBorder()
        }
        
        actionButton.setBackgroundColor(.white, forState: .normal)
        actionButton.setTitleColor(.black, for: .normal)
        
        actionButton.layer.cornerRadius = 8
        actionButton.layer.masksToBounds = true
        
        actionButton.setAction(block: { button in
            self.action.handler()
        }, for: .touchUpInside)
    }
}

