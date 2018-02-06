//
//  GuestCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/26/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

protocol GuestCellDelegate {
    func onCheckIn(cell: GuestCell)
}

class GuestCell: UICollectionViewCell {
    
    var delegate: GuestCellDelegate?
    
    /// Guest object
    var guest: Guest? {
        didSet {
            guard let guest = guest else {
                return
            }
            
            /// Name label
            nameLabel.text = guest.fullName
            
            /// Order number
            orderNumberLabel.text = "Order ID: \(guest.orderItemID)"
            
            /// Inventory info label
            inventoryInfoLabel.text = "\(guest.inventoryName) \(guest.inventoryItemTitle)"
            
            checkInButton.isHidden = guest.checkInStatus
            checkedInIcon.isHidden = !guest.checkInStatus
            
            noteIcon.isHidden = guest.notes == nil
        }
    }
    
    // MARK: UI Elements
    private lazy var noteIcon: UIImageView = {
       
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "note-blue-icon").imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        view.tintColor = UIColor.defaultGreen
        
        return view
    }()
    
    private lazy var checkedInIcon: UIImageView = {
       
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "check-green-icon").imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        view.tintColor = UIColor.defaultBlue
        
        return view
    }()
    
    private lazy var orderNumberLabel: UILabel = {
       
        let label = UILabel()
        label.font = UIFont.type(type: .markPro, size: 15)
        label.isWindlessable = true
        
        return label
    }()
    
    private lazy var inventoryInfoLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.type(type: .markPro, size: 15)
        label.isWindlessable = true
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
       
        let label = UILabel()
        label.font = UIFont.type(type: .markPro, style: .medium, size: 17)
        
        return label
    }()
    
    lazy var checkInButton: UIButton = { [unowned self] in
       
        let button = UIButton.button(style: .black)
        button.addTarget(self, action: #selector(onCheckIn(_:)), for: .touchUpInside)
        button.layer.shadowOpacity = 0
        
        let title = NSAttributedString(string: "CHECK IN", attributes: [.font: UIFont.type(type: .markPro, size: 10), .kern: 2.0, .foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Guest name
        addSubview(nameLabel)
        nameLabel.sizeToFit()
        nameLabel.snp.updateConstraints { maker in
            maker.top.equalToSuperview().offset(15)
            maker.left.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-40)
        }
        
        /// Note icon
        addSubview(noteIcon)
        noteIcon.snp.updateConstraints { maker in
            maker.height.width.equalTo(30)
            maker.right.equalToSuperview().offset(-10)
            maker.top.equalToSuperview().offset(15)
        }
        
        /// Inventory label
        addSubview(inventoryInfoLabel)
        inventoryInfoLabel.sizeToFit()
        inventoryInfoLabel.snp.updateConstraints { maker in
            maker.left.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-15)
            maker.top.equalTo(nameLabel.snp.bottom)
        }
        
        /// Order number layout
        addSubview(orderNumberLabel)
        orderNumberLabel.snp.updateConstraints { maker in
            maker.top.equalTo(inventoryInfoLabel.snp.bottom).offset(5)
            maker.left.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-15)
            maker.bottom.equalToSuperview().offset(-10)
        }
        
        if let _ = guest {
            /// Check in button
            addSubview(checkInButton)
            checkInButton.snp.updateConstraints { maker in
                maker.width.equalTo(110)
                maker.height.equalTo(35)
                maker.bottom.equalToSuperview().offset(-10)
                maker.right.equalToSuperview().offset(-10)
            }
        }
        
        /// Checked-in icon
        addSubview(checkedInIcon)
        checkedInIcon.snp.updateConstraints { maker in
            maker.width.height.equalTo(30)
            maker.bottom.equalToSuperview().offset(-10)
            maker.right.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: Actions
    @objc func onCheckIn(_ sender: UIButton) {
        sender.showLoader()
        delegate?.onCheckIn(cell: self)
    }
}
