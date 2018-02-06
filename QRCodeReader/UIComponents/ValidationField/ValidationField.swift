
//
//  ValidationField.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/1/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

/// Validation model
struct ValidationFieldModel {
    
    /// Copies
    var errorCopy: String?
    
    /// Placeholder setup
    var placeholder: String = ""
    
    /// Input setup
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    /// Validation
    var validationRule: ((_ input: String?) throws-> Bool)?
}

/// Status
enum ValidationFieldStatus {
    case iddle
    case failed
    case success
    case inProgress
}

protocol ValidationFieldDelegate {
    
    /// return handle
    func validationFieldHitReturn(_ field: ValidationField)
    
    /// Called when validation failed
    func validationField(_ field: ValidationField, failedWith error: Error?)
    
    /// Getting back input value
    func validationField(_ field: ValidationField, textChanged: String?)
    
    /// Called when status changes
    func validationField(_ field: ValidationField, statusChanged: ValidationFieldStatus)
}

/// Default implementation
extension ValidationFieldDelegate {
    
    func validationField(_ field: ValidationField, textChanged: String?) {}
    func validationField(_ field: ValidationField, failedWith error: Error?) {}
    func validationField(_ field: ValidationField, statusChanged: ValidationFieldStatus) {}
}

class ValidationField: UIView {
    
    /// Delegate
    var delegate: ValidationFieldDelegate?
    
    /// Color animation
    private lazy var borderAnimation: CABasicAnimation = {
        
        let color = CABasicAnimation(keyPath: "borderColor")
        
        color.duration = 0.3
        color.repeatCount = 1
        
        return color
    }()
    
    /// Model
    var model: ValidationFieldModel
    
    /// Validation input
    lazy var textInput: UITextField = { [unowned self] in
       
        let input = UITextField()
        input.font = UIFont.type(type: .markPro, style: .medium, size: 16)
        
        input.tintColor = .black
        input.autocorrectionType = .no
        input.autocapitalizationType = .none
        
        /// Model setup
        input.placeholder = model.placeholder
        input.keyboardType = model.keyboardType
        input.isSecureTextEntry = model.isSecure
        
        /// Delegate
        input.delegate = self
        input.addTarget(self, action: #selector(onTextChange(_:)), for: .editingChanged)
        
        return input
    }()
    
    /// Text input container
    lazy var textInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    /// Validation status label
    private lazy var statusLabel: UILabel = { [unowned self] in
       
        let label = UILabel()
        
        label.text = model.errorCopy
        label.font = UIFont.type(type: .markPro, size: 12)
        
        return label
    }()
    
    /// Current field text
    var text: String? {
        return textInput.text
    }
    
    /// Current validation status
    var status: ValidationFieldStatus = .iddle
    var previousStatus: ValidationFieldStatus = .iddle
    
    // MARK: Initialization
    init(model: ValidationFieldModel) {
        self.model = model
        super.init(frame: .zero)
        
        inputSetup()
        updateValidationUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutSetup() {
        
        addSubview(textInputContainer)
        textInputContainer.snp.updateConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-20)
        }
        
        textInputContainer.addSubview(textInput)
        textInput.snp.updateConstraints { maker in
            maker.bottom.top.equalToSuperview()
            maker.left.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-15)
        }
        
        addSubview(statusLabel)
        statusLabel.snp.updateConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(textInput.snp.bottom).offset(8)
        }
    }
    
    // MARK: Utilities
    @objc
    private func onTextChange(_ sender: UITextField) {
        validate(sender.text)
        delegate?.validationField(self, textChanged: sender.text)
    }
    
    /// Validation logic
    fileprivate func validate(_ input: String?) {
        
        /// Check for error
        do {
            let validationResult: Bool = try model.validationRule?(input) ?? false
            let newStatus = validationResult ? ValidationFieldStatus.success : .failed
            
            /// Check if need to change status
            if newStatus != status {
                previousStatus = status
                status = newStatus
                delegate?.validationField(self, statusChanged: status)
            }
        } catch {
            previousStatus = status
            status = .failed
            
            /// Pass error
            delegate?.validationField(self, failedWith: error)
        }
    }
    
    /// Validation UI
    private func updateValidationUI() {
        
        textInputContainer.layer.borderWidth = 1
        
        var statusColor = UIColor.red
        var borderFromColor = UIColor.defaultBlue.cgColor
        var borderToColor = UIColor.white.cgColor
        
        switch status {
        case .failed:
            statusColor = .red
            borderFromColor = previousStatus == .failed ? UIColor.red.cgColor : previousStatus == .inProgress ? UIColor.defaultBlue.cgColor : UIColor.white.cgColor
            borderToColor = UIColor.red.cgColor
            
        case .iddle, .success:
            statusColor = .clear
            borderFromColor = UIColor.defaultBlue.cgColor
            borderToColor = UIColor.clear.cgColor
            
        case .inProgress:
            statusColor = .clear
            borderFromColor = previousStatus == .failed ? UIColor.red.cgColor : previousStatus == .inProgress ? UIColor.defaultBlue.cgColor : UIColor.white.cgColor
            borderToColor = UIColor.defaultBlue.cgColor
        }
        
        statusLabel.textColor = statusColor
        UIView.transition(with: statusLabel, duration: 0.3, options: .transitionCrossDissolve, animations: { [unowned self] in
            self.statusLabel.textColor = self.status == .failed ? .red : .clear
            }, completion: nil)
        
        textInputContainer.layer.borderColor = borderToColor
        
        borderAnimation.fromValue = borderFromColor
        borderAnimation.toValue = borderToColor
        
        textInputContainer.layer.add(borderAnimation, forKey: "borderColor")
    }
    
    // MARK: Input attributes setup
    private func inputSetup() {
        
        textInput.keyboardType = model.keyboardType
        textInput.isSecureTextEntry = model.isSecure
    }
}

extension ValidationField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        previousStatus = status
        status = .inProgress
        updateValidationUI()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validate(textField.text)
        updateValidationUI()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        delegate?.validationFieldHitReturn(self)
        
        return true
    }
}
