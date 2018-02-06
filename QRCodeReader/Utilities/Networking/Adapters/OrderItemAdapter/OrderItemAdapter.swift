//
//  OrderItemAdapter.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/5/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation
import PromiseKit

enum CheckinError: Error {
    
    case checkedIn
    case refunded
    case canceled
    case undefined
}

extension CheckinError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .checkedIn:
            return "Ticket Already Scanned"
        case .refunded:
            return "Ticket Refunded"
        case .canceled:
            return "Ticket Canceled"
        case .undefined:
            return "Something went wrong, please try again (Ticket can be transferred)"
        }
    }
}

class OrderItemAdapter {
    
    /// Fetch order item with id
    ///
    /// - Parameter id: order item id
    /// - Returns: order item struct
    class func fetch(id: String)-> Promise<OrderItem> {
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "order-items/\(id)").then { response-> OrderItem in
            return try OrderItem(object: response)
        }
    }
    
    /// Checkin guest with id
    ///
    /// - Parameter orderItemID: orderItemID id
    /// - Returns: True/False
    class func checkIn(_ orderItemID: String, agentID: Int)-> Promise<Guest> {
        
        /// Params
        let params: [String: Any] = ["guid": orderItemID, "id": agentID]
        
        /// Networking
        let apiMan = APIManager.shared
        
        print(orderItemID)
        
        /// Check order item status before checking in
        return fetch(id: orderItemID).then { response-> Promise<Guest> in
            
            /// Status check
            if response.status != .canCheckIn {
                switch response.status {
                case .refunded:
                    throw CheckinError.refunded
                case .canceled:
                    throw CheckinError.canceled
                case .checkedIn:
                    throw CheckinError.checkedIn
                case .undefined:
                    throw CheckinError.undefined
                default:
                    break
                }
            }
            
            /// Continue request
            return apiMan.request(.post, path: "order-items/checkin", parameters: params).then { response-> Guest in
                
                var guest = try Guest(object: response)
                guest.checkInStatus = true
                guest.checkedInAt = Date()
                
                return guest
            }
        }
    }
    
    /// Fetch guest associated with order item GUID
    ///
    /// - Parameter eventGUID: Order item GUID
    /// - Returns: Guest struct
    class func fetchGuestFor(orderItemGUID: String)-> Promise<Guest> {
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "guests/\(orderItemGUID)").then { response-> Guest in
            return try Guest(object: response)
        }
    }
}
