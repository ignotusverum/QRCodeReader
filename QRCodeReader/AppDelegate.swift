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
import IQKeyboardManager
import JDStatusBarNotification

let AppDefaultAlertStyle = "AppDefaultAlertStyle"
let AppDefaultSuccessStyle = "AppDefaultSuccessStyle"
let AppWakeNotificationKey = "AppWakeNotificationKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// Shared
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /// Clear keychain on fresh install
        checkDefaults()
        
        /// Setup navigation flows
        setupFlows()
        
        /// Analytics
        Fabric.with([Crashlytics.self])
        
        /// Keyboard setup
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldPlayInputClicks = false
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        
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
        
        let loginFlow = UINavigationController(rootViewController: LoginViewController())
        loginFlow.navigationBar.isTranslucent = false
        
        /// Splash screen
        let sb = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let splashVC = sb.instantiateViewController(withIdentifier: "SplashScreen")
        
        /// Checks for access token and defines which flow it should present.
        if apiMan.accessToken != nil {
            
            /// Initial state - splash
            TransitionHandler.transitionTo(splashVC)
            
            /// Fetch current latest agent info
            AgentAdapter.me().then { response-> Void in
                
                /// Safety check
                guard let agent = response else {
                    TransitionHandler.transitionTo(loginFlow)
                    return
                }
                
                TransitionHandler.transitionTo(MainViewController(agent: agent))
                }.catch { _ in
                    /// Failed to retreive user - go to login
                    TransitionHandler.transitionTo(loginFlow)
            }
            
            return
        }

        /// No access token - go to login
        TransitionHandler.transitionTo(loginFlow)
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
        
        JDStatusBarNotification.addStyleNamed(AppDefaultSuccessStyle) { style -> JDStatusBarStyle! in
            
            style?.barColor = UIColor.green
            style?.textColor = UIColor.white
            style?.font = UIFont.type(type: .markPro, size: 12)
            
            style?.animationType = .bounce
            
            return style
        }
    }
    
    /// First install check
    func checkDefaults() {
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            
            /// Token reset
            let apiMan = APIManager.shared
            apiMan.accessToken = nil
            
            let config = Config.shared
            config.agentGUID = nil
            config.qrShowAlert = true
            
            // Reset baddges
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            // update the flag indicator
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize() // forces the app to update the NSUserDefaults
            
            return
        }
    }
}
