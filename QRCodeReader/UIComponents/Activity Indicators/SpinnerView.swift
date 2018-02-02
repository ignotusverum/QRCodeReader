//
//  SpinnerView.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/25/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

class SpinnerView: UIView {
    
    private var indicatorImageView: UIImageView!
    
    var imageName: String? {
        didSet { indicatorImageView.image = UIImage(named: imageName!) }
    }
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorImageView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Actions
    
    private func customInit() {
        indicatorImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        indicatorImageView.image = #imageLiteral(resourceName: "small_spinner_default")
        indicatorImageView.contentMode = .scaleAspectFit
        addSubview(indicatorImageView)
        
        startSpinning()
    }
    
    public func startSpinning() {
        stopSpinning()
        indicatorImageView.isHidden = false
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = Double.pi * 2.0
        animation.duration = 0.60
        animation.isCumulative = true
        animation.repeatDuration = Double.greatestFiniteMagnitude
        indicatorImageView.layer.add(animation, forKey: "rotationAnimation")
    }
    
    public func stopSpinning() {
        indicatorImageView.layer.removeAllAnimations()
        indicatorImageView.isHidden = true
    }
}
