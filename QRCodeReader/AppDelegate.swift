//
//  AppDelegate.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import KeychainAccess
import JDStatusBarNotification

let AppDefaultAlertStyle = "AppDefaultAlertStyle"
let AppWakeNotificationKey = "AppWakeNotificationKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// Shared
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    /// Default keychain
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupFlows()
        
        /// Analytics
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    /// Setup main application flows
    private func setupFlows() {
    
        window = UIWindow()
        window?.makeKeyAndVisible()
    
        /// Alert status view
        setupStatusAlertView()
        
        let apiMan = APIManager.shared
        if let cookies = apiMan.cookies {
            
            /// Checking for expired cookie
            for cookie in cookies {
                if cookie.expiresDate ?? Date() < Date() {
                    APIManager.shared.cookies = nil
                }
            }
        }
        
        window?.rootViewController = MainViewController()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: AppWakeNotificationKey), object: nil)
    }
    
    // MARK: Utilities
    func setupStatusAlertView() {
        
        JDStatusBarNotification.addStyleNamed(AppDefaultAlertStyle) { style -> JDStatusBarStyle! in
            
            style?.barColor = UIColor.errorRed
            style?.textColor = UIColor.white
            style?.font = UIFont.type(type: .markPro, size: 12)
            
            style?.animationType = .bounce
            
            return style
        }
    }
}
