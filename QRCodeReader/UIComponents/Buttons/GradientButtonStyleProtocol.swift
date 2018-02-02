//
//  ButtonStyleProtocol.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/12/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

//MARK: - ButtonStyleProtocol

protocol ButtonStyleProtocol {
    
    /// Contains all properties to set in a button for its initial state.
    ///
    /// - Parameter button: Closure that returns button to stylize.
    func initialState(button: @escaping () -> UIButton)
    
    /// Contains all properties to set in a button for its normal state.
    ///
    /// - Parameter button: Closure that returns button to stylize.
    func normalState(button: @escaping () -> UIButton)
    
    /// Contains all properties to set in a button for its highlighed state.
    ///
    /// - Parameter button: Closure that returns button to stylize.
    func highlightedState(button: @escaping () -> UIButton)
    
    /// Contains all properties to set in a button for its inactive state.
    ///
    /// - Parameter button: Closure that returns button to stylize.
    func inactiveState(button: @escaping () -> UIButton)
    
    /// Gradiient colors to use in buttons gradient layer.
    ///
    /// - Returns: Array of CGColors.
    func gradientColors() -> [CGColor]
}

//MARK: - ButtonStyleProtocol Extension

extension ButtonStyleProtocol {
    
    /// Set up for a layers black shadow.
    ///
    /// - Parameters:
    ///   - layer: Layer to add shadow.
    ///   - shadowOpacity: Opacity of shadow.
    ///   - shadowRadius: Blur radius of shadow.
    ///   - shadowOffset: Offet of shadow.
    func enableShadow(for layer: CALayer, shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
    
    /// Removes shadow from layer by turning it's opacity to 0.
    ///
    /// - Parameter layer: Layer to remove shadow.
    func disableShadow(for layer: CALayer) {
        layer.shadowOpacity = 0
    }
}
