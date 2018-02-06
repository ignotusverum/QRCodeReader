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
    
    /// Current agent
    var agent: Agent
    
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
    lazy var searchFlow: UINavigationController = { [unowned self] in
        
        let vc = EventsViewController(agent: agent)
        
        let navigation = UINavigationController(rootViewController: vc)
        navigation.navigationBar.isTranslucent = false
        
        return navigation
    }()
    
    lazy var settingsVC: AccountViewController = { [unowned self] in
        return AccountViewController(agent: agent)
    }()
    
    lazy var settingsFlow: UINavigationController = { [unowned self] in
        
        let navigation = UINavigationController(rootViewController: self.settingsVC)
        navigation.navigationBar.isTranslucent = false
        
        return navigation
    }()
    
    // MARK: Init
    init(agent: Agent) {
        self.agent = agent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Contoller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.cookies = HTTPCookieStorage.shared.cookies
        
        /// Init controllers
        viewControllers = controllers
        
        /// Setup tabbar
        setupTabBar()
        
        /// Handle controller actions
        handleControllers()
        
        let _ = AgentAdapter.me()
    }
    
    /// Controller handlers
    func handleControllers() {
        
        settingsVC.onLogout { [unowned self] in
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

