//
//  SettingsViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/29/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

enum SettingsDatasource: String {
    case qrWeb = "Enable web checkin ?"
    case qrModal = "Show confirmation checkin ? (Only works when web disabled)"
    
    static let allValues = [qrWeb, qrModal]
}

class SettingsViewController: UIViewController {
    
    /// Collection datasource
    var datasource = SettingsDatasource.allValues
    
    /// Collection View
    var collectionView: UICollectionView = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        
        /// Inset
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        /// Cell registration
        collectionView.register(SwitcherCell.self, forCellWithReuseIdentifier: "\(SwitcherCell.self)")
        
        return collectionView
    }()
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.white
        
        /// Title
        setTitle("Settings")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Initial setup
    func setupLayout() {
        
        /// Back
        setBackButton()
        
        /// Collection view
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection view layout
        collectionView.snp.updateConstraints { maker in
            maker.top.bottom.left.right.equalToSuperview()
        }
    }
}

// MARK: - CollectionView Delegate
extension SettingsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

// MARK: - CollectionView Datasource
extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        if indexPath.row != 0 {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}

// MARK: - CollectionView Datasource
extension SettingsViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SwitcherCell.self)", for: indexPath) as! SwitcherCell
        
        let type = datasource[indexPath.row]
        
        /// Cell setup
        cell.delegate = self
        cell.indexPath = indexPath
        cell.text = type.rawValue
        
        let config = Config.shared
        
        switch type {
        case .qrModal:
            cell.radioButton.isOn = config.qrShowAlert
        case .qrWeb:
            cell.radioButton.isOn = config.qrWebEnabled
        }
        
        return cell
    }
}

// MARK: - Switcher delegate
extension SettingsViewController: SwitcherCellDelegate {
    func switcherChangedTo(value: Bool, indexPath: IndexPath) {

        let config = Config.shared
        
        let type = datasource[indexPath.row]
        
        switch type {
        case .qrWeb:
            config.qrWebEnabled = value
        case .qrModal:
            config.qrShowAlert = value
        }
    }
}


