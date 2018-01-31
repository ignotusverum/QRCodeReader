//
//  FormInputProtocol.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/24/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

protocol FormInputCellDelegate {
    
    /// Text field did change
    func textFieldDidChange(_ textField: UITextField, indexPath: IndexPath)
    
    /// Return button pressed
    func textFieldHitReturn(_ textField: UITextField, indexPath: IndexPath)
}

extension FormInputCellDelegate {
    /// Return button pressed
    func textFieldHitReturn(_ textField: UITextField, indexPath: IndexPath) {}
    
    /// Text field did change
    func textFieldDidChange(_ textField: UITextField, indexPath: IndexPath) {}
}

protocol FormInputCellProtocol {
    
    /// Placeholder
    var placeholder: String! { get set }
    
    /// Index path
    var indexPath: IndexPath! { get set }
    
    /// Form input
    var formInput: UITextField { get set }
    
    /// Delegate
    var delegate: FormInputCellDelegate? { get set }
}

extension FormInputCellProtocol where Self: UICollectionViewCell {
    
    /// Generate form input
    func generateFormInput()-> UITextField {
        
        let textField = UITextField(frame: .zero)
        
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.tintColor = UIColor.black
        textField.font = UIFont.type(type: .markPro)
        
        return textField
    }
}
