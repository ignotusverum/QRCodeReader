//
//  AppDelegate.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupFlows()
        
        return true
    }
    
    /// Setup main application flows
    private func setupFlows() {
    
        window = UIWindow()
        window?.makeKeyAndVisible()
    
        window?.rootViewController = MainViewController()
    }
}

