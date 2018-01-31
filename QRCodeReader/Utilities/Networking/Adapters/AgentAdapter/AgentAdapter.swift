//
//  UserAdapter.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/24/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

/// JSON
import Marshal

/// Utilities
import Common
import PromiseKit

class AgentAdapter {
    
    /// Authentication call
    class func login(email: String, password: String)-> Promise<(authToken: String, userID: String)> {
        
        /// Parameters
        let params: [String: Any] = ["email": email, "password": password]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "login", parameters: params, ignoreAuthenticationError: false).then { response-> (authToken: String, userID: String) in
            
            let token: String = try response <| "token"
            let userID: String = try response <| "userID"
            
            return (authToken: token, userID: userID)
        }
    }
    
    /// Fetching user data
    class func me()-> Promise<Agent?> {
        
        let config = Config.shared
        guard let currentAgentID = config.agentGUID else {
            return Promise(value: nil)
        }
        
//        let currentAgentID = "297c55b2-f7d0-4dfc-a840-d6d43beda769"
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "agents/\(currentAgentID)").then { response-> Agent in
            
            print(response)
            
            let agent = try Agent(object: response)
            
            /// Update current agent
            config.currentAgent = agent
            
            return agent
        }
    }
}
