//
//  FilterType.swift
//  Tracker
//

import Foundation

// MARK: - FilterType
@objc
enum FilterType: Int, Codable {
    case all
    case today
    case completed
    case incompleted

    var name: String {
        switch self {
        case .all: return L.Filters.all
        case .today: return L.Filters.today
        case .completed: return L.Filters.completed
        case .incompleted: return L.Filters.incompleted
        }
    }
}
