//
//  GuestCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/26/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

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
            
            /// Order number
            orderNumberLabel.text = "Order id: \(guest.orderItemID)"
            
            /// Initials view
            initialsView.copyString = "\(guest.firstName) \(guest.lastName)"
            
            /// Inventory info label
            inventoryInfoLabel.text = "\(guest.inventoryName)\n\(guest.inventoryItemTitle)"
            
            checkInButton.isHidden = guest.checkInStatus
            checkedIninfoLabel.isHidden = !guest.checkInStatus
            
            /// Checked in info
            guard let date = guest.checkedInAt?.defaultFormat else {
                return
            }
            
            checkedIninfoLabel.text = "Checked in at:\n\(date)"
        }
    }
    
    // MARK: UI Elements
    private lazy var orderNumberLabel: UILabel = {
       
        let label = UILabel()
        label.font = UIFont.type(type: .markPro, size: 12)
        label.isWindlessable = true
        
        return label
    }()
    
    private lazy var initialsView: NameInitialsView = {
       
        let view = NameInitialsView()
        view.isWindlessable = true
        
        return view
    }()
    
    private lazy var inventoryInfoLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.type(type: .markPro, size: 14)
        label.isWindlessable = true
        
        return label
    }()
    
    lazy var checkInButton: UIButton = { [unowned self] in
       
        let button = UIButton.button(style: .defaultButton)
        button.setTitle("Check in", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.type(type: .markPro)
        button.setBackgroundColor(.white, forState: .normal)
        button.addTarget(self, action: #selector(onCheckIn(_:)), for: .touchUpInside)
        button.layer.shadowOpacity = 0
        
        return button
    }()
    
    private lazy var checkedIninfoLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.type(type: .markPro, style: .medium, size: 12)
        label.textAlignment = .center
        label.isWindlessable = true
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Order number layout
        addSubview(orderNumberLabel)
        orderNumberLabel.snp.updateConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview().offset(5)
            maker.width.equalTo(100)
            maker.height.equalTo(40)
        }
        
        /// User info view
        addSubview(initialsView)
        initialsView.snp.updateConstraints { maker in
            maker.top.equalTo(orderNumberLabel.snp.bottom)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalTo(90)
        }
        
        /// Inventory label
        addSubview(inventoryInfoLabel)
        inventoryInfoLabel.snp.updateConstraints { maker in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalTo(50)
            maker.top.equalTo(initialsView.snp.bottom).offset(5)
        }
        
        if let _ = guest {
            /// Check in button
            addSubview(checkInButton)
            checkInButton.snp.updateConstraints { maker in
                maker.bottom.equalToSuperview().offset(-10)
                maker.left.equalToSuperview().offset(20)
                maker.right.equalToSuperview().offset(-20)
                maker.top.equalTo(inventoryInfoLabel.snp.bottom).offset(10)
            }
        }
        
        /// Check in info
        addSubview(checkedIninfoLabel)
        checkedIninfoLabel.snp.updateConstraints { maker in
            maker.bottom.equalToSuperview().offset(-10)
            maker.left.equalToSuperview().offset(5)
            maker.right.equalToSuperview().offset(-5)
            maker.top.equalTo(inventoryInfoLabel.snp.bottom).offset(5)
        }
    }
    
    // MARK: Actions
    @objc func onCheckIn(_ sender: UIButton) {
        sender.showLoader()
        delegate?.onCheckIn(cell: self)
    }
}
