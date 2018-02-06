//
//  GuestDetailsViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/1/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

enum GuestDetailsDatasource {
    case name
    
    case orderID
    case ticketNumber
    
    case note
    case email
    case phone
    
    case checkInInfo
    case checkInButton

    case inventoryInfo
    
    static let allValues = [name, inventoryInfo, orderID, ticketNumber, email, phone, note, checkInInfo, checkInButton]
}

class GuestDetailsViewController: UIViewController {
    
    /// Guest model
    var guest: Guest
    
    /// Collection datasource
    private let datasource: [GuestDetailsDatasource] = GuestDetailsDatasource.allValues
    
    /// Background image
    private lazy var backgroundImage: UIImageView = {
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "default-background"))
        return imageView
    }()
    
    /// Collection setup
    lazy private var collectionView: UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: "\(TitleCell.self)")
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "\(ButtonCell.self)")
        collectionView.register(TitleImageCell.self, forCellWithReuseIdentifier: "\(TitleImageCell.self)")
        
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    // MARK: Iitialization
    init(guest: Guest) {
        self.guest = guest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(guest.orderItemID)
        print(guest.orderItemGUID)
        
        layoutSetup()
    }
    
    private func layoutSetup() {
        
        /// Background img layout
        view.addSubview(backgroundImage)
        backgroundImage.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
        
        /// Collection view
        view.addSubview(collectionView)
        collectionView.snp.updateConstraints { maker in
            maker.top.left.equalTo(20)
            maker.right.bottom.equalTo(-20)
        }
    }
}

extension GuestDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        let type = datasource[indexPath.row]
        
        var height: CGFloat = 44
        let width: CGFloat = collectionView.frame.width - 40
        
        /// Define height based on type
        if type == .checkInButton  {
            
            height = !guest.checkInStatus ? 90 : 0
        } else if type == .note {
            if let note = guest.notes {
                height = note.heightWithConstrainedWidth(width, font: UIFont.type(type: .markPro, size: 17))
            } else {
                height = 0
            }
        } else if type == .checkInInfo {
            
            height = guest.checkInStatus ? 60 : 0
        }
    
        return CGSize(width: width, height: height)
    }
}

extension GuestDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = datasource[indexPath.row]
        
        /// Title cell type for all datasource except check-in || notes
        if type != .checkInInfo, type != .checkInButton, type != .note {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleCell.self)", for: indexPath) as! TitleCell
            
            var title = ""
            switch type {
            case .name:
                title = guest.fullName
                cell.titleLabel.font = UIFont.type(type: .markPro, style: .medium, size: 17)
            case .inventoryInfo:
                title = "\(guest.inventoryName) \(guest.inventoryItemTitle)"
            case .orderID:
                title = "Order ID: \(guest.orderItemID)"
            case .ticketNumber:
                title = "Ticket x out of y"
            case .phone:
                title = guest.phoneNumber ?? ""
            case .email:
                title = guest.email ?? ""
            default:
                title = ""
            }
            
            cell.text = title
            cell.backgroundColor = .white
            cell.dividerView.isHidden = true
            
            return cell
        } else if type == .checkInButton {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ButtonCell.self)", for: indexPath) as! ButtonCell
            
            cell.delegate = self
            cell.indexPath = indexPath
            cell.backgroundColor = .white
            
            cell.clipsToBounds = true
            cell.buttonTitle = "CHECK IN"
            
            return cell
        }
        
        /// All other types
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleImageCell.self)", for: indexPath) as! TitleImageCell
        
        var image = UIImage()
        var title = ""
        switch type {
        case .note:
            image = #imageLiteral(resourceName: "pencil_icon")
            cell.iconImageView.tintColor = .defaultBlue
            title = guest.notes ?? ""
        case .checkInInfo:
            image = #imageLiteral(resourceName: "checkmark_icon")
            cell.iconImageView.tintColor = .defaultGreen
            
            /// Checked in info
            if let date = guest.checkedInAt?.defaultFormat {
                title = "Checked in at:\n\(date)"
            }
            
        default:
            print("Not handled \(self)")
        }
        
        cell.title = title
        cell.image = image
        cell.clipsToBounds = true
        cell.backgroundColor = .white
        
        return cell
    }
}

/// Checkin cell callback
extension GuestDetailsViewController: ButtonCellDelegate {
    func onButton(_ cell: ButtonCell, indexPath: IndexPath) {
        
        /// Do networking call, update controller
        guard let agentID = Config.shared.currentAgent?.id else {
            return
        }
        
        let orderID = guest.orderItemGUID
        OrderItemAdapter.checkIn(orderID, agentID: agentID).then { [unowned self] response-> Void in
            
            self.guest = response
            cell.button.hideLoader()
            self.collectionView.reloadData()
            }.catch { [unowned self] error in
                NavigationStatusView.showError(controller: self, subtitle: error.localizedDescription)
                cell.button.hideLoader()
        }
    }
}
