//
//  WeekDay.swift
//  Tracker
//

import Foundation


// MARK: - WeekDay
enum WeekDay: String, Codable, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var name: String {
        switch self {
        case .monday:    return L.WeekDay.monday
        case .tuesday:   return L.WeekDay.tuesday
        case .wednesday: return L.WeekDay.wednesday
        case .thursday:  return L.WeekDay.thursday
        case .friday:    return L.WeekDay.friday
        case .saturday:  return L.WeekDay.saturday
        case .sunday:    return L.WeekDay.sunday
        }
    }

    var abbreviatedName: String {
        switch self {
        case .monday:    return L.WeekDay.mo
        case .tuesday:   return L.WeekDay.tu
        case .wednesday: return L.WeekDay.we
        case .thursday:  return L.WeekDay.th
        case .friday:    return L.WeekDay.fr
        case .saturday:  return L.WeekDay.sa
        case .sunday:    return L.WeekDay.su
        }
    }
}
