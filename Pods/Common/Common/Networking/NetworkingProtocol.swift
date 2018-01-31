//
//  NetworkingProtocol.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/17/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

// Parsing
import Marshal

// Networking
import Alamofire

// Asynch
import PromiseKit

/// General error
public let AuthenticationError = NSError(domain: "Fevo.com", code: 401, userInfo: nil)

public protocol NetworkingProtocol {
    
    /// Networking header
    var headers: HTTPHeaders { get set }
    
    /// Api header Access
    var accessToken: String? { get set }
    
    /// Default networking setup
    var manager: SessionManager { get set }
    
    /// Header configuration
    func configureHeader()
    
    // MARK: - Path builder
    func baseURL(path: String)-> URL
    
    // MARK: - HTTP Request + Promise
    func request<T>(_ method: HTTPMethod, path URLString: String, parameters: [String: Any]?, handleUnAuthenticatedError: Bool, responseType: T.Type) -> Promise<T>
}

public extension NetworkingProtocol {
    // MARK: - HTTP Request + Promise
    func request<T>(_ method: HTTPMethod, path URLString: String, parameters: [String: Any]? = nil, handleUnAuthenticatedError: Bool = false, responseType: T.Type) -> Promise<T> {
        configureHeader()
        
        let path = baseURL(path: URLString)
        
        print(path)
        
        return Promise { fulfill, reject in
            manager.request(path, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if let value = response.result.value, let json = value as? T {
                            fulfill(json)
                        }
                        
                    case .failure(let error):
                        
                        print(error)
                        
                        if response.response?.statusCode == 401 {
                            reject(AuthenticationError)
                        }
                        
                        reject(error)
                    }
            }
        }
    }
}

/// Error extension
public extension Error {
    public var code: Int { return (self as NSError).code }
    public var domain: String { return (self as NSError).domain }
}

