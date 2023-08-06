//
//  WeekDay.swift
//  Tracker
//

import Foundation

// MARK: - WeekDay
enum WeekDay: String, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var name: String {
        self.rawValue.capitalized.localized()
    }

    var abbreviatedName: String {
        switch self {
        case .monday:    return "Mo".localized()
        case .tuesday:   return "Tu".localized()
        case .wednesday: return "We".localized()
        case .thursday:  return "Th".localized()
        case .friday:    return "Fr".localized()
        case .saturday:  return "Sa".localized()
        case .sunday:    return "Su".localized()
        }
    }
}
