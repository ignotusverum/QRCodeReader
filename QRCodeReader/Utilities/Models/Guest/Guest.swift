//
//  Guest.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/26/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Marshal

enum GuestJSONKeys: String {
    case firstName
    case lastName
    
    case email
    case phoneNumber
    
    case profileImageURL
    
    case notes
    case checkInStatus
    
    case inventoryName
    case inventoryItemTitle
    
    case orderItemID = "orderItemId"
    
    case checkedInAt
    
    case orderItemGUID = "orderItemGuid"
    
    case zoneID = "zoneId"
    case checkedInAgentID = "checkedInAgentId"
}

struct Guest: Unmarshaling {
    var lastName: String
    var firstName: String
    
    var email: String?
    var phoneNumber: String?
    
    var profileImageAbsolutePath: String?
    
    var notes: String?
    var checkInStatus: Bool
    
    var inventoryName: String
    var inventoryItemTitle: String
    
    var orderItemID: Int
    
    var checkedInAt: Date?
    
    var zoneID: String
    var checkedInAgentID: Int?
    
    var orderItemGUID: String
    
    /// Full name
    var fullName: String {
        
        var fullNameString = firstName
        if lastName.count > 0 {
            
            let additionalSpace = firstName.count > 0 ? " " : ""
            fullNameString = fullNameString + additionalSpace + lastName
        }
        
        return fullNameString
    }
    
    init(object: MarshaledObject) throws {
        lastName = try object.value(for: GuestJSONKeys.lastName.rawValue)
        firstName = try object.value(for: GuestJSONKeys.firstName.rawValue)
        
        email = try? object.value(for: GuestJSONKeys.email.rawValue)
        phoneNumber = try? object.value(for: GuestJSONKeys.phoneNumber.rawValue)
        
        profileImageAbsolutePath = try? object.value(for: GuestJSONKeys.profileImageURL.rawValue)
        
        orderItemID = try object.value(for: GuestJSONKeys.orderItemID.rawValue)
        
        /// TODO: Checked in returns in ms, need to put to single format
        if let timestamp: TimeInterval = try? object.value(for: GuestJSONKeys.checkedInAt.rawValue) {
            checkedInAt = Date(timeIntervalSince1970: timestamp/1000)
        }
        
        notes = try? object.value(for: GuestJSONKeys.notes.rawValue)
        checkInStatus = try object.value(for: GuestJSONKeys.checkInStatus.rawValue)
        
        inventoryName = try object.value(for: GuestJSONKeys.inventoryName.rawValue)
        inventoryItemTitle = try object.value(for: GuestJSONKeys.inventoryItemTitle.rawValue)
        
        zoneID = try object.value(for: GuestJSONKeys.zoneID.rawValue)
        checkedInAgentID = try? object.value(for: GuestJSONKeys.checkedInAgentID.rawValue)
        
        orderItemGUID = try object.value(for: GuestJSONKeys.orderItemGUID.rawValue)
    }
}

