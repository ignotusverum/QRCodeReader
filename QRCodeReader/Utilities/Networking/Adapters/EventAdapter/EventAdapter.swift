//
//  EventAdapter.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/25/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation
import PromiseKit

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
        }
    }
}
