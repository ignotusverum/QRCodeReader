//
//  EventAdapter.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/25/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

/// Utils
import PromiseKit

/// JSON parsing
import Marshal

class EventAdapter {
    
    /// Fetches full event details
    ///
    /// - Parameter eventID: Event id
    /// - Returns: Event struct
    class func fetch(eventID: Int)-> Promise<Event> {
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "events/\(eventID)").then { response-> Event in
            return try Event(object: response)
            }.then { response-> Promise<Event> in
                return Promise<Event> { fulfill, reject in
                    /// Try fetch venue associated with event
                    VenueAdapter.fetch(id: response.venueID).then { venueResponse-> Void in
                        
                        var event = response
                        event.venueName = venueResponse.name
                        
                        fulfill(event)
                        }.catch { error in
                            reject(error)
                    }
                }
        }
    }
    
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
    
    /// Find guests associated with event
    ///
    /// - Parameters:
    ///   - eventID: event id associated with guests
    ///   - query: queryString
    /// - Returns: array of guests
    class func findGuestsFor(eventID: Int, query: String)-> Promise<[Guest]> {
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "events/\(eventID)/search/\(query)", responseType: [MarshalDictionary].self).then { response-> [Guest] in
            return response.flatMap { try? Guest(object: $0) }
        }
    }
}
