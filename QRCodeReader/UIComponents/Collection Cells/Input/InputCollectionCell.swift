//
//  InputCollectionCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/24/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation
import IQKeyboardManager

class InputCollectionCell: UICollectionViewCell, FormInputCellProtocol, DividerCellProtocol {
    
    /// Delegate
    var delegate: FormInputCellDelegate?
    
    /// Index path
    var indexPath: IndexPath!
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Placeholder
    var placeholder: String! {
        didSet {
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 7
            
            formInput.attributedPlaceholder = NSAttributedString(string: placeholder.capitalizeFirst(), attributes: [NSAttributedStringKey.font: UIFont.type(type: .markPro), NSAttributedStringKey.paragraphStyle: paragraph])
        }
    }
    
    /// Form input
    lazy var formInput: UITextField = self.generateFormInput()
    
    // MARK: - Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider
        dividerLayout()
        
        /// Form input
        addSubview(formInput)
        formInput.delegate = self
        formInput.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        /// Details layout
        formInput.snp.updateConstraints { maker in
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().offset(-20)
            maker.top.equalToSuperview().offset(15)
            maker.bottom.equalToSuperview().offset(-15)
        }
    }
}

extension InputCollectionCell: UITextFieldDelegate {
    @objc func textFieldDidChange(textField: UITextField) {
        delegate?.textFieldDidChange(textField, indexPath: indexPath)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldHitReturn(textField, indexPath: indexPath)
        return true
    }
}
