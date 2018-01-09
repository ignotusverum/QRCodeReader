//
//  MainViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Foundation

private enum TabTitles: String, CustomStringConvertible {
    case camera
    case favorites
    
    internal var description: String {
        return rawValue.capitalizeFirst()
    }
    
    static let allValues = [camera, favorites]
}

private var tabIcons = [
    TabTitles.camera: "camera",
    TabTitles.favorites: "favorites"
]

class MainViewController: UITabBarController {
    
    /// Controllers
    lazy var controllers: [UIViewController] = { [unowned self] in
       
        var results: [UIViewController] = []
        
        /// Setup datasource
        results.append(self.cameraFlow)
        results.append(self.favoritesFlow)
        
        return results
    }()
    
    /// Tab bar flows
    lazy var cameraFlow: UINavigationController = {
       
        let vc = CameraViewController()
        let navigation = UINavigationController(rootViewController: vc)
        
        return navigation
    }()
    
    lazy var favoritesFlow: UINavigationController = {
       
        let vc = FavoritesViewController()
        let navigation = UINavigationController(rootViewController: vc)
        
        return navigation
    }()
    
    // MARK: - Contoller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Init controllers
        viewControllers = controllers
        
        /// Setup tabbar
        setupTabBar()
    }
    
    // MARK: - Utilities
    /// Switches tabbar to specific title enum
    ///
    /// - Parameter title: switching title enum
    private func switchTo(title: TabTitles) {
        guard let index = TabTitles.allValues.index(of: title) else {
            return
        }
        
        /// Transition
        selectedIndex = index
    }
    
    /// Setup tabbar appearance
    private func setupTabBar() {
        
        /// Make it solid
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.black
        
        for (index, tabBarItem) in TabTitles.allValues.enumerated() {
            
            /// Safety check
            guard let item = tabBar.items?[index] else {
                return
            }
            
            item.tag = index
            item.image = UIImage(named: tabBarItem.description)
            item.selectedImage = UIImage(named: "\(tabBarItem.description)_selected")
        }
    }
}
