//
//  NetworkingProtocol.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/17/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

// Networking
import Alamofire

// Asynch
import PromiseKit

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
    func request(_ method: HTTPMethod, path URLString: String, parameters: [String: Any]?) -> Promise<Any>
}

public extension NetworkingProtocol {
    // MARK: - HTTP Request + Promise
    func request(_ method: HTTPMethod, path URLString: String, parameters: [String: Any]? = nil) -> Promise<Any> {
        configureHeader()
        
        let path = baseURL(path: URLString)
        
        return Promise { fulfill, reject in
            manager.request(path, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        if let value = response.result.value {
                            fulfill(value)
                        }
                        
                    case .failure(let error):
                        reject(error)
                    }
            }
        }
    }
}

