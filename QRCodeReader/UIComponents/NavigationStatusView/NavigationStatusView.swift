//
//  NavigationStatusView.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/5/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import SwiftMessages

enum NavigationStatus {
    case success
    case failure
    
    func getBackgroundColor()-> UIColor {
        return self == .success ? .navigationSuccess : .navigationFailure
    }
    
    func getIcon()-> UIImage {
        return self == .success ? #imageLiteral(resourceName: "success_icon_navigation") : #imageLiteral(resourceName: "failure_icon_navigation")
    }
}

class NavigationStatusView: MessageView {
    
    /// Title lbael
    @IBOutlet var headerLabel: UILabel?
    
    // MARK: - Show notificaiton
    class func showError(controller: UIViewController, title: String = "Oops, something went wrong", subtitle: String) {
        showNotification(controller: controller, title: title, subtitle: subtitle, status: .failure)
    }
    
    class func showNotification(controller: UIViewController, title: String = "Oops, something went wrong", subtitle: String, status: NavigationStatus) {

        let backgroundView: NavigationStatusView = try! SwiftMessages.viewFromNib()
        
        backgroundView.titleLabel?.text = title
        backgroundView.bodyLabel?.text = subtitle
        backgroundView.iconImageView?.image = status.getIcon()
        backgroundView.backgroundColor = status.getBackgroundColor()

        backgroundView.clipsToBounds = true

        /// Message setup
        let messageView = MessageView(frame: .zero)
        messageView.layoutMargins = .zero
        messageView.installContentView(backgroundView, insets: .zero)

        let bg = UIView()
        messageView.installBackgroundView(bg)

        messageView.configureDropShadow()
        messageView.safeAreaTopOffset = -6
        var config = SwiftMessages.defaultConfig

        config.presentationContext = .viewController(controller)

        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            SwiftMessages.show(config: config, view: messageView)
        }
    }
}
