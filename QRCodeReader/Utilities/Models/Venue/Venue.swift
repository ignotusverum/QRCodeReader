//
//  Venue.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/5/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Marshal
import Foundation

enum VenueJSONKeys: String {
    case id
    case guid
    
    case createdAt
    case updatedAt
    
    case name
    case description
    case cityID = "cityId"
    
    case postalCode = "zipcode"
    case addressString = "address"
}

struct Venue: Unmarshaling {

    var id: Int
    var guid: String
    
    var createdAt: Date
    var updatedAt: Date?
    
    var name: String
    var description: String?
    
    var cityID: Int?
    var postalCode: String?
    
    var addressString: String?
    
    init(object: MarshaledObject) throws {
        
        id = try object.value(for: VenueJSONKeys.id.rawValue)
        guid = try object.value(for: VenueJSONKeys.guid.rawValue)
        
        createdAt = try object.value(for: VenueJSONKeys.createdAt.rawValue)
        updatedAt = try? object.value(for: VenueJSONKeys.updatedAt.rawValue)
        
        name = try object.value(for: VenueJSONKeys.name.rawValue)
        description = try? object.value(for: VenueJSONKeys.description.rawValue)
        
        cityID = try? object.value(for: VenueJSONKeys.cityID.rawValue)
        
        postalCode = try? object.value(for: VenueJSONKeys.postalCode.rawValue)
        addressString = try? object.value(for: VenueJSONKeys.addressString.rawValue)
    }
}
