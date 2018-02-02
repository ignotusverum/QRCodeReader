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
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.type(type: .sharpSans, style: .bold, size: 23)
        
        return label
    }()
    
    /// Email label
    lazy var emailLabel: UILabel = {
        
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.type(type: .markPro, size: 17)
        
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
        label.font = UIFont.type(type: .markPro, size: 30)
        
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
            maker.height.equalTo(80)
            maker.width.equalTo(80)
            maker.top.equalTo(20)
            maker.left.equalToSuperview().offset(20)
        }
        
        /// Name label layout
        nameLabel.snp.updateConstraints { maker in
            maker.height.equalTo(40)
            maker.width.equalToSuperview().offset(-100)
            maker.left.equalTo(initialsLabel.snp.right).offset(10)
            maker.centerY.equalToSuperview().offset(-10)
        }
        
        /// Email label layout
        emailLabel.snp.updateConstraints { maker in
            maker.height.equalTo(30)
            maker.centerY.equalToSuperview().offset(10)
            maker.left.equalTo(initialsLabel.snp.right).offset(10)
            maker.width.equalToSuperview().offset(-100)
        }
    }
}

