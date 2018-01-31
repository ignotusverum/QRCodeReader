//
//  Marshal.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/25/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Marshal

extension Date : ValueType {
    public static func value(from object: Any) throws -> Date {
        
        if object is String || object is Int {
            if let dateString = object as? String {
                // assuming you have a Date.fromISO8601String implemented...
                guard let date = dateString.dateFromISO8601 else {
                    throw MarshalError.typeMismatch(expected: "ISO8601 date string", actual: dateString)
                }
                
                return date
            } else if let timestamp = object as? TimeInterval {
                return Date(timeIntervalSince1970: timestamp)
            }
            
            return Date()
        } else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
    }
}
