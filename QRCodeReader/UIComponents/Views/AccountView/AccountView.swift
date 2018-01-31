//
//  AccountView.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/29/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

class AccountView: UIView {
    
    /// Agent model
    var agent: Agent {
        didSet {
            /// Update
            customInit()
            
            /// Layout update
            layoutSubviews()
        }
    }
    
    /// Name label
    lazy var nameLabel: UILabel = {
        
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.type(type: .sharpSans, style: .bold, size: 34)
        
        return label
    }()
    
    /// Email label
    lazy var emailLabel: UILabel = {
        
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.type(type: .markPro, size: 20)
        
        return label
    }()
    
    /// Initials label
    lazy var initialsLabel: UILabel = {
        
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.font = UIFont.type(type: .markPro, size: 44)
        
        return label
    }()
    
    // MARK: - Initialization
    init(agent: Agent) {
        self.agent = agent
        super.init(frame: .zero)
        
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("account view not coder init not implemented ")
    }
    
    func customInit() {
        
        /// Clear background
        backgroundColor = UIColor.white
        
        /// Name setup
        nameLabel.text = agent.fullName
        
        /// Email Setup
        emailLabel.text = agent.email
        
        /// Initials setup
        initialsLabel.text = agent.initials
    }
    
    // MARK: - Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        /// Name Label
        addSubview(nameLabel)
        
        /// Email Label
        addSubview(emailLabel)
        
        /// Initial label
        addSubview(initialsLabel)
        
        /// Initials label layout
        initialsLabel.snp.updateConstraints { maker in
            maker.height.equalTo(128)
            maker.width.equalTo(128)
            maker.top.equalTo(42)
            maker.centerX.equalTo(self)
        }
        
        /// Name label layout
        nameLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(128 + 42 + 16)
            maker.height.equalTo(40)
            maker.centerX.equalTo(self)
            maker.width.equalTo(self)
        }
        
        /// Email label layout
        emailLabel.snp.updateConstraints { maker in
            maker.top.equalTo(nameLabel.snp.bottom).offset(2)
            maker.height.equalTo(30)
            maker.centerX.equalTo(self)
            maker.width.equalTo(self)
        }
        
        /// Layers - initials
        initialsLabel.layer.cornerRadius = 128 / 2
        initialsLabel.clipsToBounds = true
    }
}

