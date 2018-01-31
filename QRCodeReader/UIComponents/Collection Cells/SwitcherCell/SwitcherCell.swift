//
//  SwitcherCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/29/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

protocol SwitcherCellDelegate {
    
    /// Switcher changed
    func switcherChangedTo(value: Bool, indexPath: IndexPath)
}

class SwitcherCell: UICollectionViewCell, DividerCellProtocol, TitleCellProtocol {
    
    /// Delegate
    var delegate: SwitcherCellDelegate?
    
    var indexPath: IndexPath!
    
    /// Title text
    var text: String! {
        didSet {
            /// Set title text
            titleLabel.text = text
            titleLabel.numberOfLines = 0
        }
    }
    
    /// Title
    lazy var titleLabel: UILabel = self.generateTitleLabel()
    
    /// Divider
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Radio button
    var radioButton: UISwitch = {
        
        var radioButton = UISwitch(frame: .zero)
        return radioButton
    }()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider layout
        dividerLayout()
        
        /// Title label
        addSubview(titleLabel)
        titleLabel.textColor = textColor
        
        /// Title label layout
        titleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-100)
            maker.height.equalTo(self)
            maker.top.equalTo(self)
        }
        
        /// Radio button
        addSubview(radioButton)
        radioButton.addTarget(self, action: #selector(switcherChanged(sender:)), for: .valueChanged)
        
        /// Radio button layout
        radioButton.snp.updateConstraints { maker in
            maker.right.equalTo(self).offset(-25)
            maker.width.equalTo(60)
            maker.height.equalTo(32)
            maker.centerY.equalTo(self)
        }
    }
    
    // MARK: - Actions
    @objc
    func switcherChanged(sender: UISwitch) {
        
        /// Delegate call
        delegate?.switcherChangedTo(value: sender.isOn, indexPath: indexPath)
    }
}
