//
//  Date+Extensions.swift
//  Tracker
//

import Foundation

extension Date {

    func stripTime() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.timeZone = NSTimeZone.system
        guard let date = Calendar.current.date(from: components) else {
            fatalError("Date has not been created from components \(components)")
        }
        return date
    }
    
    var dayOfTheWeek: WeekDay {
        var weekdays: [WeekDay] = WeekDay.allCases
        if let sunday = weekdays.popLast(), sunday == WeekDay.sunday {
            weekdays.insert(sunday, at: 0)
        }
        let weekdayNumber = Calendar.current.component(.weekday, from: self)
        return weekdays[weekdayNumber - 1]
    }

}
