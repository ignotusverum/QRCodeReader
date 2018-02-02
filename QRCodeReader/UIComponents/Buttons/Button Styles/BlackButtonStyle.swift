//
//  BlackButtonStyle.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/1/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

struct BlackButtonStyle: ButtonStyleProtocol {
    func gradientColors() -> [CGColor] {
        return []
    }
    
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
        button().titleLabel?.alpha = 1
        button().backgroundColor = UIColor.black
        
        enableShadow(for: button().layer, shadowOpacity: 0.2, shadowRadius: 4, shadowOffset: CGSize(width: 0, height: 1))
    }
    
    func highlightedState(button: @escaping () -> UIButton) {
        button().backgroundColor = .black
        disableShadow(for: button().layer)
    }
    
    func inactiveState(button: @escaping () -> UIButton) {
        button().titleLabel?.alpha = 0.3
        disableShadow(for: button().layer)
        button().backgroundColor = UIColor.black
    }
}
