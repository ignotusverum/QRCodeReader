//
//  DefaultButtonStyle.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/26/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

struct DefaultButtonStyle: ButtonStyleProtocol {
    
    func titleAttributedString(text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text.uppercased())
        attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(2), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.type(type: .markPro), range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    func initialState(button: @escaping () -> UIButton) {
        normalState { () -> UIButton in
            return button()
        }
    }
    
    func normalState(button: @escaping () -> UIButton) {
        button().alpha = 1
    }
    
    func highlightedState(button: @escaping () -> UIButton) {
    }
    
    func inactiveState(button: @escaping () -> UIButton) {
        button().alpha = 0.3
        disableShadow(for: button().layer)
    }
    
    func gradientColors() -> [CGColor] {
        return [UIColor.firstGradient.cgColor, UIColor.secondGradient.cgColor]
    }
}

