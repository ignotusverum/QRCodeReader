//
//  GuestAdapter.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/26/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

/// JSON parsing
import Marshal

/// Utils
import PromiseKit

class GuestAdapter {
    /// Fetches guest structs for event
    ///
    /// - Parameter eventID: event id
    /// - Returns: guest structs associated with event
    class func fetchGuestsFor(eventID: Int)-> Promise<[Guest]> {
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "events/\(eventID)/guests", responseType: [MarshalDictionary].self).then { response-> [Guest] in
            return response.flatMap { try? Guest(object: $0) }
        }
    }
    
    /// Checkin guest with id
    ///
    /// - Parameter guestID: Guest id
    /// - Returns: True/False
    class func checkIn(_ orderID: String, agentID: Int)-> Promise<Guest> {
        
        /// Params
        let params: [String: Any] = ["guid": orderID, "id": agentID]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "checkin", parameters: params).then { response-> Guest in
            
            var guest = try Guest(object: response)
            guest.checkInStatus = true
            guest.checkedInAt = Date()
            
            return guest
        }
    }
    
    /// Fetch guest associated with order item GUID
    ///
    /// - Parameter eventGUID: Order item GUID
    /// - Returns: Guest struct
    class func fetchGuestFor(orderItemGUID: String)-> Promise<Guest> {
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "event_guest/\(orderItemGUID)").then { response-> Guest in
            return try Guest(object: response)
        }
    }
}
