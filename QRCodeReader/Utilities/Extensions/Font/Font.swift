//
//  Font.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Foundation

enum FontType: String {
    case markPro = "MarkOT"
    case sharpSans = "SharpSansNo1"
}

enum FontStyle: String {
    case medium = "Medium"
    
    case bold
    case boldItalic
    
    case regular = ""
}

extension UIFont {
    
    /// Default font setup
    static func type(type: FontType, style: FontStyle = .regular, size: CGFloat = 14)-> UIFont {
        let style = style != .regular ? "-\(style.rawValue)" : ""
        return UIFont(name: "\(type.rawValue)\(style)", size: size)!
    }
}


