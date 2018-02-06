//
//  APIManager.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/17/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

/// Networking
import Alamofire

/// Utils
import Common
import PromiseKit

/// JSON
import Marshal

//localhost:3000
//"checkin.fevo.com"
//api-mobile-stage.fevo.com:3000
let hostName = "localhost:3000"

public let NetworkingManagerAccessTokenKey = "NetworkingManagerAccessTokenKey"
public let NetworkingManagerCookiesTokenKey = "NetworkingManagerCookiesTokenKey"

/// General error
public let GeneralError = NSError(domain: hostName, code: 1001, userInfo: nil)

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
            return UserDefaults.standard.object(forKey: NetworkingManagerAccessTokenKey) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: NetworkingManagerAccessTokenKey)
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
        
        headers["Authorization"] = "Bearer \(accessToken)"
    }
    
    /// Base URL setup
    func baseURL(path: String) -> URL {
        return URL(string: "http://\(hostName)/\(path)")!
    }
    
    /// Networking request with predefined response type
    func request(_ method: HTTPMethod, path URLString: String, parameters: [String : Any]? = nil, ignoreAuthenticationError: Bool = true) -> Promise<MarshalDictionary> {
        return request(method, path: URLString, parameters: parameters, responseType: MarshalDictionary.self).catch { error in
            
            if error.code == 401, ignoreAuthenticationError {
                /// Handle logout & redirect
                TransitionHandler.signOut()
            }
        }
    }
}
