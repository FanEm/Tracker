//
//  Category.swift
//  Tracker
//

import Foundation

// MARK: - Category
struct Category: Codable, Equatable {
    let name: String
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name
    }
}
