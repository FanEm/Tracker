//
//  Date+Extensions.swift
//  Tracker
//

import Foundation

extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day, .timeZone], from: self)
        guard
            let date = Calendar.current.date(from: components)
        else {
            fatalError("Date has not been created from components \(components)")
        }
        return date
    }
    
    func dayOfTheWeek() -> WeekDay {
        let weekdays: [WeekDay] = [
            .sunday, .monday, .tuesday, .wednesday,.thursday, .friday, .saturday
        ]
        guard
            let weekdayNumber = Calendar.current.dateComponents([.weekday], from: self).weekday
        else {
            fatalError("Unknown weekday")
        }
        return weekdays[weekdayNumber - 1]
    }
}
