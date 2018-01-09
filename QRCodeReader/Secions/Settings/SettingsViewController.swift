//
//  SettingsViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Foundation

private enum SettingsCellTitles: String {
    
    case linkOpen = "Link Open"
    case browser
    case support
    
    static let allValues = [linkOpen, browser, support]
}

class SettingsViewController: UIViewController {
    
    /// Collection datasource
    fileprivate var datasource = SettingsCellTitles.allValues
    
}
