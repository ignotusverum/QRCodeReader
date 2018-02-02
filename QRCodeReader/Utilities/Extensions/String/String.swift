//
//  String.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Foundation

extension String {
    func capitalizeFirst() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var noSpaces: String {
        var string = self
        if string.contains(" "){
            string =  string.replacingOccurrences(of: " ", with: "")
        }
        
        return string
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, spacing: CGFloat = 0) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font, .paragraphStyle : paragraphStyle], context: nil)
        
        return boundingBox.height
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension NSAttributedString {
    
    func changeTextColor(_ color: UIColor)-> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([.foregroundColor: color], range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
}
