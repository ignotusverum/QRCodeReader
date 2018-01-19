//
//  Colors.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/11/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    static let errorRed = UIColor.hex("#f76451")
    
    /// Reds
    static let defaultRed = UIColor.hex("#901A35")
    
    /// Gradients
    static let firstGradient = UIColor.hex("#901A35")
    static let secondGradient = UIColor.hex("#391464")
    
    class func hex(_ hexString: String)-> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
