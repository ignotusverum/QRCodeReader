//
//  OnboardingRouteHandler.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/18/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

class OnboardingRouteHandler {
 
    class func rootTransition() {

        guard let window = AppDelegate.shared.window else {
            return
        }
        
        let webVC = WebViewController(url: URL(string: "https://checkin\(Config.envWebString).fevo.com")!)
        let webFlow = UINavigationController(rootViewController: webVC)
        webFlow.navigationBar.isTranslucent = false
        webVC.handleCookiesUdpate {
            TransitionHandler.transitionTo(MainViewController())
        }
        webVC.onClose {
            TransitionHandler.transitionTo(MainViewController())
        }
        
        /// Navigation setup
        window.rootViewController = webFlow
    }
}
