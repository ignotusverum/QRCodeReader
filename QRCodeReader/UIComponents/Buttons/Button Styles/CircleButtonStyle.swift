//
//  CircleButtonStyle.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/12/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

struct CircleButtonStyle: ButtonStyleProtocol {
    
    func initialState(button: @escaping () -> UIButton) {
        normalState { () -> UIButton in
            return button()
        }
    }
    
    func normalState(button: @escaping () -> UIButton) {
        button().alpha = 1
        enableShadow(for: button().layer, shadowOpacity: 0.3, shadowRadius: 4, shadowOffset: CGSize(width: 0, height: 4))
    }
    
    func highlightedState(button: @escaping () -> UIButton) {
        enableShadow(for: button().layer, shadowOpacity: 0.3, shadowRadius: 2, shadowOffset: CGSize(width: 0, height: 2))
    }
    
    func inactiveState(button: @escaping () -> UIButton) {
        button().alpha = 0.3
        disableShadow(for: button().layer)
    }
    
    func gradientColors() -> [CGColor] {
        return [UIColor.firstGradient.cgColor, UIColor.secondGradient.cgColor]
    }
}

