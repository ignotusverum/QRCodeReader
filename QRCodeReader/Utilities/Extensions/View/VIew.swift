//
//  VIew.swift
//  Prod
//
//  Created by Vladislav Zagorodnyuk on 1/24/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func makeRound() {
        
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    func addShadow(cornerRadius: CGFloat = 0.0) {
        
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.1
        clipsToBounds = false
        
        let shadowFrame: CGRect = layer.bounds
        let shadowPath: CGPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: cornerRadius).cgPath
        layer.shadowPath = shadowPath
    }
    
    func addGradientBorder(lineWidth: CGFloat = 0.5) {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientLayer.frame = bounds
        
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        gradientLayer.mask = shape
        gradientLayer.cornerRadius = layer.cornerRadius
        
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.colors = [UIColor.firstGradient.cgColor, UIColor.secondGradient.cgColor]
        
        layer.addSublayer(gradientLayer)
    }
    
    func addBottomBorder() {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.withAlphaComponent(0.2).cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
}
