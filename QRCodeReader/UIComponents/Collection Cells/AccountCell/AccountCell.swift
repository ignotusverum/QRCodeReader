//
//  AccountCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/2/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

class AccountCell: UICollectionViewCell {
    
    var agent: Agent!
    
    lazy var accountView: AccountView = { [unowned self] in
       
        let view = AccountView(agent: agent)
        view.backgroundColor = .clear
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
        
        addSubview(accountView)
        accountView.snp.updateConstraints { maker in
            maker.top.left.right.bottom.equalToSuperview()
        }
    }
}
