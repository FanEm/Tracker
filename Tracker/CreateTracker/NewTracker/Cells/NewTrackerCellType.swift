//
//  NewTrackerCellType.swift
//  Tracker
//

// MARK: - NewTrackerCellType
enum NewTrackerCellType: String {
    case category
    case schedule
    
    var name: String {
        switch self {
        case .category: return L.Category.title
        case .schedule: return L.Schedule.title
        }
    }
}
