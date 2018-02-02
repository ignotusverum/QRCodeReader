//
//  LoginViewController.swift
//  Prod
//
//  Created by Vladislav Zagorodnyuk on 1/24/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation
import PromiseKit
import JDStatusBarNotification

/// LoginVC datasource with validation logic
enum LoginViewControllerCellType: String {
    case email = "email"
    case password
    
    func validationModel()-> ValidationFieldModel {
        switch self {
        case .email:
            
            var model = ValidationFieldModel()
            
            model.placeholder = "Email"
            model.keyboardType = .emailAddress
            model.errorCopy = "Please enter a valid email address"
            model.validationRule = Validation.isValidEmail(_:)
            
            return model
            
        case .password:
            
            var model = ValidationFieldModel()
            
            model.isSecure = true
            model.placeholder = "Password"
            model.errorCopy = "Please enter a valid password"
            model.validationRule = Validation.isValidPassword(_:)
            
            return model
        }
    }
}

class LoginViewController: UIViewController {
    
    // MARK: iVars
    /// Datasource
    fileprivate let datasource: [LoginViewControllerCellType] = [.email, .password]
    
    /// Networking params
    fileprivate var email: String?
    fileprivate var password: String?
    
    fileprivate var emailFormInput: UITextField?
    
    // MARK: UI
    private lazy var backgroundImage: UIImageView = {
       
        let imageView = UIImageView(image: #imageLiteral(resourceName: "default-background"))
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        
        let button = UIButton.button(style: .black)
        button.setTitle("SIGN IN", for: .normal)
        
        /// Hide button
        button.alpha = 0
        
        return button
    }()
    
    private lazy var collecionView: UICollectionView = { [unowned self] in
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ValidationCell.self, forCellWithReuseIdentifier: "\(ValidationCell.self)")
        
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Hide view
        collectionView.alpha = 0
        
        return collectionView
    }()
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
        
        /// Image setup
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        
        /// Layout
        layoutSetup()
        
        /// Forward button handler
        loginButton.setAction(block: { [unowned self] sender in
            self.onLogin()
            }, for: .touchUpInside)
        
        /// Show keyboard after delay
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) { [unowned self] in
            self.emailFormInput?.becomeFirstResponder()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Initial animation
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.collecionView.alpha = 1
            self.loginButton.alpha = 1
        }
    }
    
    private func layoutSetup() {
        
        /// Background img layout
        view.addSubview(backgroundImage)
        backgroundImage.snp.updateConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
        
        /// Collection view layout
        view.addSubview(collecionView)
        collecionView.snp.updateConstraints { maker in
            maker.height.equalTo(190)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().offset(-70)
            maker.top.equalToSuperview().offset(60)
        }
        
        /// Forward btn layout
        view.addSubview(loginButton)
        loginButton.snp.updateConstraints { maker in
            maker.height.equalTo(60)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().offset(-70)
            maker.top.equalTo(collecionView.snp.bottom).offset(20)
        }
    }
    
    // MARK: Utilities
    fileprivate func onLogin() {
        handleLogin()
    }
    
    private func handleLogin() {
        /// Validation
        guard let email = email, let password = password else {
            JDStatusBarNotification.show(withStatus: "Please enter email & password.", dismissAfter: 2.0, styleName: AppDefaultAlertStyle)
            return
        }
        
        do {
            let _ = try Validation.isValidEmail(email)
            let _ = try Validation.isValidPassword(password)
        } catch {
            JDStatusBarNotification.show(withStatus: error.localizedDescription, dismissAfter: 2.0, styleName: AppDefaultAlertStyle)
            return
        }
        
        /// Loading
        handleLoading(true)
        
        /// Authentication call
        AgentAdapter.login(email: email, password: password).then { response-> Promise<Agent?> in
            
            /// Update token & config
            let apiMan = APIManager.shared
            apiMan.accessToken = response.authToken
            
            let config = Config.shared
            config.agentGUID = response.userID
            
            /// Fetch current agent
            return AgentAdapter.me()
            }.then { [unowned self] response-> Void in
                
                /// UI Updates
                self.handleLoading(false)
                
                /// Safety check
                guard let agent = response else {
                    throw GeneralError
                }
                
                /// Transition
                TransitionHandler.transitionTo(MainViewController(agent: agent))
            }.catch { [unowned self] error in
                self.handleLoading(false)
                self.emailFormInput?.becomeFirstResponder()
                JDStatusBarNotification.show(withStatus: error.localizedDescription, dismissAfter: 2.0, styleName: AppDefaultAlertStyle)
        }
    }
    
    private func handleLoading(_ isLoading: Bool) {
        if isLoading {
            
            /// Block user interactions untill completed
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            /// Dismiss keyboard
            view.endEditing(true)
            
            /// Loading
            loginButton.showLoader()
            
            return
        }
        
        loginButton.hideLoader()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

extension LoginViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 95)
    }
}

extension LoginViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ValidationCell.self)", for: indexPath) as! ValidationCell
        
        let type = datasource[indexPath.row]

        cell.inputModel = type.validationModel()
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        /// Used to present initial keyboard
        if indexPath.row == 0 {
            emailFormInput = cell.textInput
        }
        
        return cell
    }
}

extension LoginViewController: ValidationCellDelegate {
    
    /// Return button pressed
    func textFieldHitReturn(_ textField: UITextField, indexPath: IndexPath) {
        /// Hit return on last cell
        if indexPath.row == datasource.count {
            onLogin()
        }
    }

    /// Text field did change
    func validationField(_ field: ValidationField, textChanged: String?, indexPath: IndexPath) {
        
        let type = datasource[indexPath.row]
        switch type {
        case .email:
            email = field.status == .success ? textChanged : nil
        case .password:
            password = field.status == .success ? textChanged : nil
        }
    }
}
