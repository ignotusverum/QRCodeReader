//
//  EmptyView.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/11/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class EmptyView: UIView {
    
    private var attributedTitle: NSAttributedString
    
    private lazy var titleLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    init(title: String) {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        paragraph.alignment = .center
        
        self.attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedStringKey.paragraphStyle: paragraph, NSAttributedStringKey.font: UIFont.type(type: .sharpSans, style: .bold, size: 30)])
        
        super.init(frame: .zero)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openSettings))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .white
        addSubview(titleLabel)
        
        titleLabel.attributedText = attributedTitle
        
        titleLabel.snp.updateConstraints { [unowned self] maker in
            maker.left.equalToSuperview().offset(40)
            maker.right.equalToSuperview().offset(-40)
            maker.top.bottom.equalTo(self)
        }
    }
    
    // MARK: Utilities
    @objc private func openSettings() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
}
