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

private enum SettingsCellTitles: String {
    
    case support
    
    var image: UIImage {
        switch self {
        case .support:
            return #imageLiteral(resourceName: "support")
        }
    }
    
    static let allValues = [support]
}

class SettingsViewController: UIViewController {
    
    /// Logout handler
    var logoutHandler: (()->())?
    
    /// Collection datasource
    fileprivate var datasource = SettingsCellTitles.allValues
    
    /// Collection setup
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(TitleImageCell.self, forCellWithReuseIdentifier: "\(TitleImageCell.self)")
        
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
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

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section < datasource.count {
            
            let type = datasource[indexPath.section]
            
            switch type {
            case .support:
                /// Show mail client
                composeEmail()
            }
            
            return
        }
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}

extension SettingsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleImageCell.self)", for: indexPath) as! TitleImageCell
        
        /// Cell setup
        let titleModel = datasource[indexPath.row]
        cell.setupTitle(titleModel.rawValue, iconImage: titleModel.image)
        
        return cell
    }
}

// MARK: - Email composer
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        dismiss(animated: true, completion: nil)
    }
}
