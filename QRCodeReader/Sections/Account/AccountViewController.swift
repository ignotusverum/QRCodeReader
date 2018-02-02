//
//  SettingsViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/17/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

private enum AccountCellTitles: String {
    
    case account
    case qrWeb = "Enable web checkin ?"
    case signOut
    case contactInfo = "CONTACT FEVO"
    
    static let allValues = [account, qrWeb, signOut, contactInfo]
}

class AccountViewController: UIViewController {
    
    /// Current agent
    var agent: Agent
    
    /// Logout handler
    var logoutHandler: (()->())?
    
    /// Initials label
    var initialsLabel: UILabel?
    
    /// Collection datasource
    fileprivate var datasource = AccountCellTitles.allValues
    
    /// Collection setup
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(SwitcherCell.self, forCellWithReuseIdentifier: "\(SwitcherCell.self)")
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "\(ButtonCell.self)")
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: "\(TitleCell.self)")
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: "\(AccountCell.self)")
        
        collectionView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "default-background"))
        
        return collectionView
    }()
    
    // MARK: Initialization
    init(agent: Agent) {
        self.agent = agent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initialsLabel?.makeRound()
        initialsLabel?.addGradientBorder(lineWidth: 2)
    }
    
    func layoutSetup() {
        
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        
        /// CollectionView layout
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.updateConstraints { maker in
            maker.top.bottom.left.right.equalToSuperview()
        }
    }
    
    // MARK: Utilities
    func composeEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setSubject("I would like ...")
            mail.setToRecipients(["support@fevo.com"])
            
            navigationController?.present(mail, animated: true)
        } else {
            
            let alertController = UIAlertController(title: "Whoops", message: "Looks like you disabled emails", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(okAction)
            navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func onLogout(_ logout: @escaping (()->())) {
        logoutHandler = logout
    }
}

extension AccountViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section < datasource.count {
            
            let type = datasource[indexPath.section]
            if type == .contactInfo {
                composeEmail()
            }
        }
    }
}

extension AccountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 120)
        }
        
        return CGSize(width: collectionView.frame.width, height: 90)
    }
}

extension AccountViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = datasource[indexPath.section]
        
        print(type)
        
        switch type {
        case .account:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AccountCell.self)", for: indexPath) as! AccountCell
            
            cell.agent = agent
            initialsLabel = cell.accountView.initialsLabel
            
            return cell
        case .qrWeb:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SwitcherCell.self)", for: indexPath) as! SwitcherCell
            
            /// Cell setup
            cell.delegate = self
            cell.indexPath = indexPath
            cell.text = type.rawValue
            
            let config = Config.shared
            cell.radioButton.isOn = config.qrWebEnabled
            
            cell.dividerView.isHidden = true
            
            return cell
            
        case .signOut:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ButtonCell.self)", for: indexPath) as! ButtonCell
            cell.indexPath = indexPath
            cell.delegate = self
            cell.buttonTitle = "SIGN OUT"
            
            return cell
            
        case .contactInfo:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleCell.self)", for: indexPath) as! TitleCell
            cell.text = "CONTACT FEVO"
            cell.dividerView.isHidden = true
            cell.titleLabel.textAlignment = .center
            
            return cell
        }
    }
}

// MARK: - Email composer
extension AccountViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension AccountViewController: SwitcherCellDelegate {
    /// Switcher changed
    func switcherChangedTo(value: Bool, indexPath: IndexPath) {
        let config = Config.shared
        config.qrWebEnabled = value
    }
}

extension AccountViewController: ButtonCellDelegate {
    func onButton(_ cell: ButtonCell, indexPath: IndexPath) {
        /// Signout handler
        TransitionHandler.signOut()
    }
}
