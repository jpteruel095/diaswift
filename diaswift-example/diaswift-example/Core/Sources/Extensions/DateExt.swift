//
//  DateExt.swift
//  Alamofire
//
//  Created by John Patrick Teruel on 10/29/20.
//

import Foundation

extension Date{
    /**
     Convert this date to specified format
     - parameters:
        - format: Date format (refer to https://stackoverflow.com/questions/35700281/date-format-in-swift)
     - returns: String
     */
    func toString(withFormat format: String = "MMM dd, yyyy") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func startOfDay() -> Date{
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self)
    }
    
    func endOfDay() -> Date{
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let to = calendar.date(byAdding: .day,
                               value: 1,
                               to: self.startOfDay())
        return to!
    }
}
