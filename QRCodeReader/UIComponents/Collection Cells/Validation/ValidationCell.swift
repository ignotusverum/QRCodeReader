//
//  ValidationCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/1/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

protocol ValidationCellDelegate {
    
    /// Return button pressed
    func textFieldHitReturn(_ textField: UITextField, indexPath: IndexPath)
    
    /// Text field did change
    func validationField(_ field: ValidationField, textChanged: String?, indexPath: IndexPath)
}

class ValidationCell: UICollectionViewCell {
    
    var delegate: ValidationCellDelegate?
    
    var indexPath: IndexPath!
    
    /// Input estup
    var inputModel: ValidationFieldModel!
    
    /// Validation input view
    private lazy var validationField: ValidationField = { [unowned self] in
       
        let field = ValidationField(model: inputModel)
        field.delegate = self
        
        return field
    }()
    
    /// Input
    var textInput: UITextField {
        return validationField.textInput
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
        
        /// Validation setup
        addSubview(validationField)
        validationField.snp.updateConstraints { maker in
            maker.left.top.equalToSuperview().offset(5)
            maker.right.bottom.equalToSuperview().offset(-5)
        }
    }
}

extension ValidationCell: ValidationFieldDelegate {
    
    /// Return handle
    func validationFieldHitReturn(_ field: ValidationField) {
        delegate?.textFieldHitReturn(textInput, indexPath: indexPath)
    }
    
    /// Text did change
    func validationField(_ field: ValidationField, textChanged: String?) {
        delegate?.validationField(field, textChanged: textChanged, indexPath: indexPath)
    }
}
