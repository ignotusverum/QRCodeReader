//
//  VenueAdapter.swift
//  Prod
//
//  Created by Vladislav Zagorodnyuk on 2/5/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation
import PromiseKit

class VenueAdapter {
    
    /// Fetching venue details with id
    ///
    /// - Parameter id: venue id
    /// - Returns: venue object
    class func fetch(id: Int)-> Promise<Venue> {
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "venue/\(id)").then { response-> Venue in
            return try Venue(object: response)
        }
    }
}
