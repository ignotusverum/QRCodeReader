//
//  SettingsViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
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
    
    /// Collection datasource
    fileprivate var datasource = SettingsCellTitles.allValues
    
    /// Collection setup
    lazy var collectionView: UICollectionView = {
      
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleImageCell.self, forCellWithReuseIdentifier: "\(TitleImageCell.self)")
        
        return collectionView
    }()
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
    }
    
    func layoutSetup() {
        
        setTitle("Settings")
        
        /// CollectionView layout
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.updateConstraints { [unowned self] maker in
            maker.top.bottom.left.right.equalTo(self.view)
        }
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
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
