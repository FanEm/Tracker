//
//  NewTrackerCellType.swift
//  Tracker
//

// MARK: - NewTrackerCellType
enum NewTrackerCellType: String {
    case category
    case schedule
    
    var name: String {
        self.rawValue.capitalized.localized()
    }
}
