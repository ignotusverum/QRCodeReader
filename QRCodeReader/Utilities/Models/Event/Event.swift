//
//  Event.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/25/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Marshal

enum EventJSONKeys: String {
    case id
    case guid
    
    case createdAt
    case updatedAt
    
    case venueID = "venueId"
    case adminUserID = "adminUserId"
    
    case title
    
    case endDate
    case startDate
    
    case numberOfGuests
    case numberOfCheckedInGuests
}

struct Event: Unmarshaling, Codable {

    var id: Int
    var guid: String
    
    var createdAt: Date
    var updatedAt: Date?
    
    var venueID: Int
    var adminUserID: Int
    
    var title: String
    
    var endDate: Date
    var startDate: Date
    
    var numberOfGuests: Int
    var numberOfCheckedInGuests: Int
    
    var venueName: String?
    
    init(object: MarshaledObject) throws {
        
        id = try object.value(for: EventJSONKeys.id.rawValue)
        guid = try object.value(for: EventJSONKeys.guid.rawValue)
        
        createdAt = try object.value(for: EventJSONKeys.createdAt.rawValue)
        updatedAt = try? object.value(for: EventJSONKeys.updatedAt.rawValue)
        
        venueID = try object.value(for: EventJSONKeys.venueID.rawValue)
        adminUserID = try object.value(for: EventJSONKeys.adminUserID.rawValue)
        
        title = try object.value(for: EventJSONKeys.title.rawValue)
        
        endDate = try object.value(for: EventJSONKeys.endDate.rawValue)
        startDate = try object.value(for: EventJSONKeys.startDate.rawValue)
        
        numberOfGuests = try object.value(for: EventJSONKeys.numberOfGuests.rawValue)
        numberOfCheckedInGuests = try object.value(for: EventJSONKeys.numberOfCheckedInGuests.rawValue)
    }
}

