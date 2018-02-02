//
//  Date.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/25/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    public var year: Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        return calendar.component(Calendar.Component.year, from: self)
    }
    
    public var month: Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        return calendar.component(Calendar.Component.month, from: self)
    }
    
    public var day: Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        return calendar.component(Calendar.Component.day, from: self)
    }
    
    public var hour: Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        return calendar.component(Calendar.Component.hour, from: self)
    }
    
    public var minute: Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        return calendar.component(Calendar.Component.minute, from: self)
    }
    
    var defaultFormat: String? {
        
        /// Check if current year
        let dateYear = year
        let currentYear = Date().year
        
        let localFormatter = DateFormatter()
        localFormatter.timeZone = TimeZone.current
        localFormatter.dateFormat = "d MMM h:mm a yyyy"
        
        /// Do not show current year
        if currentYear >= dateYear {
            localFormatter.dateFormat = "d MMM h:mm a"
        }
        
        return localFormatter.string(from: self)
    }
    
    static func startFormat(_ start: Date, end: Date)-> String {
        
        let startFormatter = DateFormatter()
        startFormatter.timeZone = TimeZone.current
        
        let endFormatter = DateFormatter()
        endFormatter.timeZone = TimeZone.current
        
        let currentYear = Date().year
        
        var startDateFormat = "d MMM yyyy\nh:mm a"
        var endDateFormat = "d MMM yyyy h:mm a"
        
        if currentYear == start.year {
            endDateFormat = endDateFormat.replacingOccurrences(of: "yyyy ", with: "")
            startDateFormat = startDateFormat.replacingOccurrences(of: "yyyy", with: "")
        }
        
        /// Check if date equal
        startFormatter.dateFormat = startDateFormat
        let startResult = startFormatter.string(from: start)
        if start == end {
            return startResult
        }
        
        if start.year == end.year {
            endDateFormat = endDateFormat.replacingOccurrences(of: "yyyy ", with: "")
        }
        
        if start.month == end.month {
            endDateFormat = endDateFormat.replacingOccurrences(of: "MMM ", with: "")
        }
        
        if start.day == end.day {
            endDateFormat = endDateFormat.replacingOccurrences(of: "d ", with: "")
        } else {
            startDateFormat = startDateFormat.replacingOccurrences(of: "\n ", with: "")
        }
        
        if start.hour == end.hour && start.minute == end.minute {
            endDateFormat = endDateFormat.replacingOccurrences(of: " h:mm a", with: "")
        }
        
        endFormatter.dateFormat = endDateFormat
        
        let endResult = endFormatter.string(from: end)
        return "\(startResult) - \(endResult)".uppercased()
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}
