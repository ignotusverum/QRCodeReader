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

enum LoginViewControllerCellType: String {
    case email = "email"
    case password
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
       
        let imageView = UIImageView(image: #imageLiteral(resourceName: "login-background"))
        return imageView
    }()
    
    private lazy var forwardButton: UIButton = {
        
        let button = UIButton.button(style: .gradient)
        button.setImage(#imageLiteral(resourceName: "forward"), for: .normal)
        button.setBackgroundColor(.white, forState: .normal)
        
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
        
        collectionView.register(InputCollectionCell.self, forCellWithReuseIdentifier: "\(InputCollectionCell.self)")
        
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Hide view
        collectionView.alpha = 0
        
        return collectionView
    }()
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        /// Image setup
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        
        /// Layout
        layoutSetup()
        
        /// Forward button handler
        forwardButton.setAction(block: { [unowned self] sender in
            self.onForward()
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
            self.forwardButton.alpha = 1
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /// Layer updates
        forwardButton.makeRound()
        collecionView.layer.cornerRadius = 10
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
            maker.height.equalTo(140)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().offset(-70)
            maker.top.equalToSuperview().offset(60)
        }
        
        /// Forward btn layout
        view.addSubview(forwardButton)
        forwardButton.snp.updateConstraints { maker in
            maker.width.height.equalTo(80)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(collecionView.snp.bottom).offset(40)
        }
    }
    
    // MARK: Utilities
    fileprivate func onForward() {
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
                JDStatusBarNotification.show(withStatus: error.localizedDescription, dismissAfter: 2.0, styleName: AppDefaultAlertStyle)
                self.handleLoading(false)
                self.emailFormInput?.becomeFirstResponder()
        }
    }
    
    private func handleLoading(_ isLoading: Bool) {
        if isLoading {
            
            /// Block user interactions untill completed
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            /// Dismiss keyboard
            view.endEditing(true)
            
            /// Loading
            forwardButton.showLoader()
            
            return
        }
        
        forwardButton.hideLoader()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

extension LoginViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
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
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(InputCollectionCell.self)", for: indexPath) as! InputCollectionCell
        
        let type = datasource[indexPath.row]
        
        /// Cell estup
        cell.placeholder = type.rawValue
        cell.indexPath = indexPath
        cell.delegate = self
        
        if type == .email {
            cell.formInput.keyboardType = .emailAddress
        } else {
            cell.formInput.isSecureTextEntry = true
        }
        
        /// Disable capitalization
        cell.formInput.autocapitalizationType = .none
        
        /// Used to present initial keyboard
        if indexPath.row == 0 {
            emailFormInput = cell.formInput
        }
        
        return cell
    }
}

extension LoginViewController: FormInputCellDelegate {
    
    /// Text field did change
    func textFieldDidChange(_ textField: UITextField, indexPath: IndexPath) {
        let type = datasource[indexPath.row]
        
        switch type {
        case .email:
            email = textField.text
        case .password:
            password = textField.text
        }
    }
    
    /// Return button pressed
    func textFieldHitReturn(_ textField: UITextField, indexPath: IndexPath) {
        /// Hit return on last cell
        if indexPath.row == datasource.count {
            onForward()
        }
    }
}
