//
//  MainViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/17/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

private enum TabTitles: String, CustomStringConvertible {
    case camera
    case settings
    case search
    
    internal var description: String {
        return rawValue.capitalizeFirst()
    }
    
    static let allValues = [search, camera, settings]
}

private var tabIcons = [
    TabTitles.search: "search",
    TabTitles.camera: "camera",
    TabTitles.settings: "settings"
]

class MainViewController: UITabBarController {
    
    /// Controllers
    lazy var controllers: [UIViewController] = { [unowned self] in
        
        var results: [UIViewController] = []
        
        /// Setup datasource
        results.append(self.searchFlow)
        results.append(self.cameraFlow)
        results.append(self.settingsFlow)
        
        return results
    }()
    
    /// Tab bar flows
    lazy var cameraFlow: UINavigationController = {
        
        let vc = CameraViewController()
        let navigation = UINavigationController(rootViewController: vc)
        navigation.navigationBar.isTranslucent = false
        
        return navigation
    }()
    
    /// Search flow
    lazy var searchV: WebViewController = {
        let vc = WebViewController(url: URL(string: "https://checkin\(Config.envWebString).fevo.com")!, type: .back)
        return vc
    }()
    
    lazy var searchFlow: UINavigationController = { [unowned self] in
        
        let navigation = UINavigationController(rootViewController: self.searchV)
        navigation.navigationBar.isTranslucent = false
        
        return navigation
    }()
    
    lazy var settingsVC: SettingsViewController = {
        return SettingsViewController()
    }()
    
    lazy var settingsFlow: UINavigationController = { [unowned self] in
        
        let navigation = UINavigationController(rootViewController: self.settingsVC)
        navigation.navigationBar.isTranslucent = false
        
        return navigation
    }()
    
    // MARK: - Contoller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if APIManager.shared.cookies == nil {
            selectedIndex = 0
            APIManager.shared.cookies = HTTPCookieStorage.shared.cookies
        } else {
            selectedIndex = 1
        }
        
        /// Init controllers
        viewControllers = controllers
        
        /// Setup tabbar
        setupTabBar()
        
        /// Handle controller actions
        handleControllers()

    }
    
    /// Controller handlers
    func handleControllers() {
        
        settingsVC.onLogout { [unowned self] in
            
            self.searchV.webView.reload()
            /// Return to initial state
            self.selectedIndex = 0
        }
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
            
            item.image = UIImage(named: tabBarItem.description)
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.selectedImage = UIImage(named: "\(tabBarItem.description)_selected")
        }
    }
}

