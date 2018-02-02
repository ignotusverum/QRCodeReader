//
//  SearchView.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/29/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

class SearchView: UIView {
    
    /// Closure for detecting when called textDidChange
    fileprivate var textDidChange: ((String?)->())?
    
    /// Closure for detecting when close button pressed
    fileprivate var onClearButton: (()->())?
    
    /// Search Icon
    lazy var searchIcon: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Search")
        imageView.tintColor = UIColor.white
        
        return imageView
    }()
    
    /// Cancel button
    lazy var cancelButton: UIButton = {
        
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: .normal)
        
        button.tintColor = UIColor.lightText
        button.backgroundColor = UIColor.clear
        
        button.addTarget(self, action: #selector(clearButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
    /// Placeholder
    var placeholder: String = "Search" {
        didSet {
            searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.type(type: .markPro)])
        }
    }
    
    /// Text field
    lazy var searchTextField: UITextField = {
        
        let textField = UITextField()
        
        textField.autocorrectionType = .no
        textField.textColor = UIColor.black
        textField.font = UIFont.type(type: .markPro)
        
        return textField
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Text did change
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.tintColor = .black
        
        /// Search icon
        addSubview(searchIcon)
        
        /// Cancel Button
        addSubview(cancelButton)
        
        /// Search text field
        addSubview(searchTextField)
        searchTextField.delegate = self
        
        /// Hide cancel initially
        cancelButton.isHidden = true
        
        /// Search layout
        searchIcon.snp.updateConstraints { maker in
            maker.centerY.equalTo(self)
            maker.left.equalTo(self).offset(24)
            maker.height.equalTo(16)
            maker.width.equalTo(16)
        }
        
        /// Cancel layout
        cancelButton.snp.updateConstraints { maker in
            maker.centerY.equalTo(self)
            maker.right.equalTo(self).offset(-27)
            maker.height.equalTo(16)
            maker.width.equalTo(16)
        }
        
        /// Search text field
        searchTextField.snp.updateConstraints { maker in
            maker.left.equalTo(24 + 17 + 10)
            maker.right.equalTo(self).offset(-20 - 16 - 5)
            maker.centerY.equalTo(self).offset(1)
        }
    }
    
    // MARK: - Utilities
    /// Text did change
    func textDidChange(_ completion: ((String?)->())?) {
        /// Completion handler
        textDidChange = completion
    }
    
    func onClearButton(_ completion: (()->())?) {
        /// completion handler
        onClearButton = completion
    }
    
    // MARK: - Actions
    @objc func clearButtonPressed(_ sender: UIButton) {
        onClearButton?()
        searchTextField.text = ""
        cancelButton.isHidden = true
    }
}

extension SearchView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != "\n"
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textDidChange?(textField.text)
        cancelButton.isHidden = (textField.text ?? "").count == 0
    }
}

