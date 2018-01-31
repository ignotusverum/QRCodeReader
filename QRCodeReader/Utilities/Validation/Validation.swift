//
//  Validation.swift
//  Prod
//
//  Created by Vladislav Zagorodnyuk on 1/24/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

enum CreateError: Error {
    
    case email
    case password
}

extension CreateError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .email:
            return NSLocalizedString("Whoops, please enter a valid email.", comment: "Validation error")
        case .password:
            return NSLocalizedString("Whoops, please enter a valid password", comment: "Validation error")
        }
    }
}

class Validation {
    
    class func isValidEmail(_ email: String?) throws-> Bool {
        
        guard let email = email else {
            throw CreateError.email
        }
        
        let emailString = email.noSpaces
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        guard emailTest.evaluate(with: emailString) == true else {
            throw CreateError.email
        }
        
        return true
    }
    
    class func isValidPassword(_ password: String?) throws-> Bool {
        
        guard let password = password, password.count > 0 else {
            throw CreateError.password
        }
        
        return true
    }
    
    class func containsSpecialCharacters(_ string: String) throws-> Bool {
        
        let characterset = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
        if string.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        
        return false
    }
}

