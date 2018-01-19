//
//  Config.swift
//  Prod
//
//  Created by Vladislav Zagorodnyuk on 1/18/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

enum EnvironmentType: String {
    case prod = "prod"
    case stage
    case unknown
    
    static let allValues = [prod, stage, unknown]
}

class Config {
    static let environmentString = Bundle.main.infoDictionary?["FEVO_ENVIRONMENT"] as! String
    
    static var environmentType: EnvironmentType {
        return EnvironmentType(rawValue: environmentString) ?? .unknown
    }
    
    static var envWebString: String {
        return Config.environmentType == .prod ? "" : "-stage"
    }
}
