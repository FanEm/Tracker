//
//  FilterType.swift
//  Tracker
//

import Foundation

// MARK: - FilterType
enum FilterType: String, Codable {
    case all
    case today
    case completed
    case inProgress
    
    var name: String {
        var name: String
        switch self {
        case .all:
            name = "All trackers"
        case .today:
            name = "Trackers for today"
        case .completed:
            name = "Сompleted"
        case .inProgress:
            name = "Not completed"
        }
        return name.localized()
    }
}
