//
//  Config.swift
//  Prod
//
//  Created by Vladislav Zagorodnyuk on 1/18/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

let AgentKey = "AgentKey"
let AgentIDKey = "AgentIDKey"
let QRWebSetupKey = "QRWebSetupKey"
let QRShowAlertKey = "QRShowAlertKey"

enum EnvironmentType: String {
    case prod = "prod"
    case stage
    case unknown
    
    static let allValues = [prod, stage, unknown]
}

class Config {
    
    /// Shared config
    static let shared = Config()

    /// Current user ID
    var agentGUID: String? {
        get {
            return UserDefaults.standard.object(forKey: AgentIDKey) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AgentIDKey)
        }
    }
    
    var qrWebEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: QRWebSetupKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: QRWebSetupKey)
        }
    }
    
    var qrShowAlert: Bool {
        get {
            return UserDefaults.standard.bool(forKey: QRShowAlertKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: QRShowAlertKey)
        }
    }
    
    var currentAgent: Agent? {
        get {
            if let data = UserDefaults.standard.object(forKey: AgentKey) as? Data {
                let result = try? PropertyListDecoder().decode(Agent.self, from: data)
                return result
            }
            return nil
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: AgentKey)
        }
    }
    
    /// URLs + build configurations =
    static let environmentString = Bundle.main.infoDictionary?["FEVO_ENVIRONMENT"] as! String
    
    /// ENV check
    static var environmentType: EnvironmentType {
        return EnvironmentType(rawValue: environmentString) ?? .unknown
    }
    
    /// Basic url setup
    static var envWebString: String {
        return Config.environmentType == .prod ? "" : "-stage"
    }
}
