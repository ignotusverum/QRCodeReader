//
//  ButtonCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/2/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

protocol ButtonCellDelegate {
    func onButton(_ cell: ButtonCell, indexPath: IndexPath)
}

class ButtonCell: UICollectionViewCell {
    
    /// Delegate
    var delegate: ButtonCellDelegate?
    
    /// Index path
    var indexPath: IndexPath!
    
    /// Button title
    var buttonTitle: String! {
        didSet {
            let title = NSAttributedString(string: buttonTitle, attributes: [.font: UIFont.type(type: .markPro), .kern: 2.0, .foregroundColor: UIColor.white])
            button.setAttributedTitle(title, for: .normal)
        }
    }
    
    /// Button
    lazy var button: UIButton = { [unowned self] in
       
        let button = UIButton.button(style: .black)
        button.setAction(block: { [unowned self] sender in
            self.delegate?.onButton(self, indexPath: self.indexPath)
        }, for: .touchUpInside)
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(button)
        button.snp.updateConstraints { maker in
            maker.top.left.equalToSuperview().offset(20)
            maker.bottom.right.equalToSuperview().offset(-20)
        }
    }
}
