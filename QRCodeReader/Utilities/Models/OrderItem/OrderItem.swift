//
//  OrderItem.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/5/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Marshal
import Foundation

enum OrderItemJSONKeys: String {
    case id
    case guid
    
    case createdAt
    case updatedAt
    
    case orderID = "orderId"
    case inventoryItemID = "inventoryItemId"
    
    case price
    case isRefunded = "refunded"
    
    case status
    case isCheckedIn = "checkInStatus"
}

enum OrderItemStatus: String {
    case reserved
    case canceled
    case checkedIn
    case refunded
    case requested
    case undefined
    case canCheckIn
}

struct OrderItem: Unmarshaling {
     
    var id: Int
    var guid: String
    
    var createdAt: Date
    var updatedAt: Date?
    
    var orderID: Int
    var inventoryItemID: Int
    
    var price: Float
    
    var isRefunded: Bool
    var isCheckedIn: Bool
    
    var statusString: String
    
    var status: OrderItemStatus {
        
        let status = isCheckedIn ? .checkedIn : OrderItemStatus(rawValue: statusString.lowercased()) ?? .undefined
        let canCheckinCheck = !isCheckedIn && status != .canceled && status != .refunded && status != .undefined
        
        return canCheckinCheck ? .canCheckIn : status
    }
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: OrderItemJSONKeys.id.rawValue)
        guid = try object.value(for: OrderItemJSONKeys.guid.rawValue)
        
        createdAt = try object.value(for: OrderItemJSONKeys.createdAt.rawValue)
        updatedAt = try? object.value(for: OrderItemJSONKeys.updatedAt.rawValue)
        
        orderID = try object.value(for: OrderItemJSONKeys.orderID.rawValue)
        inventoryItemID = try object.value(for: OrderItemJSONKeys.inventoryItemID.rawValue)
        
        price = try object.value(for: OrderItemJSONKeys.price.rawValue)
        isRefunded = try object.value(for: OrderItemJSONKeys.isRefunded.rawValue)
        
        statusString = try object.value(for: OrderItemJSONKeys.status.rawValue)
        
        isCheckedIn = try object.value(for: OrderItemJSONKeys.isCheckedIn.rawValue)
    }
}
