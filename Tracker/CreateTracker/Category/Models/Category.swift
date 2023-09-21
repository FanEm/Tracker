//
//  Category.swift
//  Tracker
//

import Foundation

// MARK: - Category
struct Category: Codable, Equatable {
    let id: UUID
    let name: String
    let type: CategoryType

    init(id: UUID, name: String, type: CategoryType = .user) {
        self.id = id
        self.name = name
        self.type = type
    }

    init(categoryCoreData: TrackerCategoryCoreData) {
        self.id = categoryCoreData.id
        self.name = categoryCoreData.name
        self.type = CategoryType(rawValue: Int(categoryCoreData.type)) ?? .user
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name
    }
}
