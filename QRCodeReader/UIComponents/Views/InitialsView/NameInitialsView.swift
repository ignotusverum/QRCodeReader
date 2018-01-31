//
//  InitialsView.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/26/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

class NameInitialsView: UIView {
    
    var copyString: String? {
        didSet {
            copyLabel.text = copyString
            
            guard let copy = copyString else {
                return
            }
            
            initialsLabel.text = copy.prefix(2).uppercased()
        }
    }
    
    /// Initials label
    private lazy var initialsLabel: UILabel = {
       
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.type(type: .sharpSans, style: .bold, size: 16)
        
        return label
    }()
    
    private lazy var copyLabel: UILabel = {
    
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.type(type: .markPro, size: 14)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(initialsLabel)
        initialsLabel.snp.updateConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview().offset(50)
            maker.right.equalToSuperview().offset(-50)
            maker.height.equalTo(60)
        }
        
        addSubview(copyLabel)
        copyLabel.snp.updateConstraints { maker in
            maker.top.equalTo(initialsLabel.snp.bottom).offset(10)
            maker.left.right.bottom.equalToSuperview()
        }
        
        initialsLabel.makeRound()
        initialsLabel.backgroundColor = .defaultGray
    }
}
