//
//  DefaultButtonStyle.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/26/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

struct DefaultButtonStyle: GradientButtonStyleProtocol {
    
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

