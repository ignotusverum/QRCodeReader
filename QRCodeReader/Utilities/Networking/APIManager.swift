//
//  APIManager.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/17/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Common
import Alamofire
import PromiseKit

//localhost:7050
//"checkin.fevo.com"
let hostName = "localhost:7050/check_in"

public let NetworkingManagerAccessTokenKey = "NetworkingManagerAccessTokenKey"
public let NetworkingManagerCookiesTokenKey = "NetworkingManagerCookiesTokenKey"

class APIManager: NetworkingProtocol {
    
    /// Shared manger
    static let shared = APIManager()
    
    /// Header setup
    var headers = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    /// Cookies - authentication
    var cookies: [HTTPCookie]? {
        get {
            let ud = UserDefaults.standard
            guard let decoded  = ud.object(forKey: NetworkingManagerCookiesTokenKey) as? Data else {
                return nil
            }
            
            let objecty = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [HTTPCookie]
            return objecty
        }
        set {
            
            let ud = UserDefaults.standard
            guard let newValue = newValue else {
                ud.set(nil, forKey: NetworkingManagerCookiesTokenKey)
                return
            }
            
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            ud.set(data, forKey: NetworkingManagerCookiesTokenKey)
        }
    }
    
    /// Api key
    var accessToken: String? {
        get {
            let keychain = AppDelegate.shared.keychain
            return keychain[NetworkingManagerAccessTokenKey]
        }
        set {
            let keychain = AppDelegate.shared.keychain
            keychain[NetworkingManagerAccessTokenKey] = newValue
        }
    }
    
    /// Default manager setup
    var manager = Alamofire.SessionManager.default
    
    /// Header configuration
    func configureHeader() {
        
        /// Safety check
        guard let accessToken = accessToken, accessToken.count > 1 else {
            headers = [:]
            return
        }
        
        headers["Authorization"] = accessToken
    }
    
    /// Base URL setup
    func baseURL(path: String) -> URL {
        return URL(string: "http://\(hostName)/\(path)")!
    }
}
