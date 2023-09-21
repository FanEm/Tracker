//
//  NewCategoryMode.swift
//  Tracker
//

import Foundation

// MARK: - NewCategoryMode
enum NewCategoryMode {
    case new
    case edit(name: String, indexPath: IndexPath)
}
