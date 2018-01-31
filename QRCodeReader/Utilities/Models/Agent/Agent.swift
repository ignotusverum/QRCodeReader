//
//  Agent.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/25/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Marshal

enum AgentJSONKeys: String {
    case id
    case guid
    
    case createdAt
    case updatedAt
    
    case initials
    case lastName
    case firstName
    
    case email
    case profileImageURL = "profileImageUrl"
    
    case phoneNumber
}

enum CheckedInEventJSONKeys: String {
    case checkInAgentEvents
    case id
}

struct Agent: Codable, Unmarshaling {

    var id: Int
    var guid: String
    
    var createdAt: Date
    var updatedAt: Date?
    
    var initials: String
    var lastName: String
    var firstName: String

    var email: String
    var profileImageAbsolute: String
    
    var phoneNumber: String
    
    var profileImageURL: URL? {
        return URL(string: profileImageAbsolute)
    }
    
    /// Full name
    var fullName: String {
        
        var fullNameString = firstName
        if lastName.count > 0 {
            
            let additionalSpace = firstName.count > 0 ? " " : ""
            fullNameString = fullNameString + additionalSpace + lastName
        }
        
        return fullNameString
    }
    
    var eventIDs: [Int] = []
    var events: [Event] = []
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: AgentJSONKeys.id.rawValue)
        guid = try object.value(for: AgentJSONKeys.guid.rawValue)
        
        createdAt = try object.value(for: AgentJSONKeys.createdAt.rawValue)
        updatedAt = try? object.value(for: AgentJSONKeys.updatedAt.rawValue)
        
        initials = try object.value(for: AgentJSONKeys.initials.rawValue)
        lastName = try object.value(for: AgentJSONKeys.lastName.rawValue)
        firstName = try object.value(for: AgentJSONKeys.firstName.rawValue)
        
        email = try object.value(for: AgentJSONKeys.email.rawValue)
        profileImageAbsolute = try object.value(for: AgentJSONKeys.profileImageURL.rawValue)
        
        phoneNumber = try object.value(for: AgentJSONKeys.phoneNumber.rawValue)
        
        /// Parsing for checkedIn events
        if let checkedInEvents: [MarshalDictionary] = try? object.value(for: CheckedInEventJSONKeys.checkInAgentEvents.rawValue) {
            
            /// Getting all event ids
            eventIDs = checkedInEvents.flatMap { try? $0.value(for: CheckedInEventJSONKeys.id.rawValue)}
        }
    }
}
