//
//  MainViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UITabBarController {
    
    /// Controllers
    var datasource: [UIViewController] = []
    
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
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func customSetup() {
        
        
    }
}
