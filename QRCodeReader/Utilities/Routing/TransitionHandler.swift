//
//  TransitionHandler.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/18/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

class TransitionHandler {
    
    class func transitionTo(_ viewController: UIViewController) {
        
        guard let window = AppDelegate.shared.window else {
            return
        }
        
        UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
            
            let oldState = UIView.areAnimationsEnabled
            
            UIView.setAnimationsEnabled(false)
            
            window.rootViewController = viewController
            
            UIView.setAnimationsEnabled(oldState)
            
        }) { finished in }
    }
}