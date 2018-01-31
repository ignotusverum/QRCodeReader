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
import ParallaxHeader

private enum AccountCellTitles: String {
    
    case contactUs = "Contact us"
    case settings
    
    static let allValues = [settings, contactUs]
}

class AccountViewController: UIViewController {
    
    /// Current agent
    var agent: Agent
    
    /// Logout handler
    var logoutHandler: (()->())?
    
    /// Collection datasource
    fileprivate var datasource = AccountCellTitles.allValues
    
    /// Collection view header view
    lazy var headerView: AccountView = { [unowned self] in
        
        let view = AccountView(agent: agent)
        return view
    }()
    
    /// Collection setup
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: "\(TitleCell.self)")
        collectionView.register(SignOutCell.self, forCellWithReuseIdentifier: "\(SignOutCell.self)")
        collectionView.register(VersionCell.self, forCellWithReuseIdentifier: "\(VersionCell.self)")
        
        collectionView.backgroundColor = .white
        
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
    
    func layoutSetup() {
        
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        
        /// Collection header setup
        collectionView.parallaxHeader.view = headerView
        collectionView.parallaxHeader.height = 280
        collectionView.parallaxHeader.minimumHeight = 80
        collectionView.parallaxHeader.mode = .centerFill
        
        /// CollectionView layout
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.updateConstraints { maker in
            maker.top.bottom.left.right.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        headerView.initialsLabel.addGradientBorder(lineWidth: 2)
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
            
            switch type {
            case .contactUs:
                /// Show mail client
                composeEmail()
            case .settings:
                let settingsVC = SettingsViewController()
                navigationController?.pushViewController(settingsVC, animated: true)
            }
        } else {
            /// Signout handler
            TransitionHandler.signOut()
        }
    }
}

extension AccountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}

extension AccountViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /// Signout button
        if indexPath.section == datasource.count + 1 {
            
            /// Sign out button
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SignOutCell.self)", for: indexPath) as! SignOutCell
            
            return cell
        } else if indexPath.section == datasource.count {
            
            /// Version setup
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(VersionCell.self)", for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleCell.self)", for: indexPath) as! TitleCell
        
        /// Cell setup
        let titleModel = datasource[indexPath.section]
        cell.text = titleModel.rawValue
        
        return cell
    }
}

// MARK: - Email composer
extension AccountViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        dismiss(animated: true, completion: nil)
    }
}
