//
//  Tracker.swift
//  Tracker
//

import UIKit

// MARK: - Tracker
struct Tracker: Codable {

    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: Set<WeekDay>
    let isPinned: Bool
    let type: NewTrackerType
    let category: Category
    let previousCategoryId: UUID?

    init(
        id: UUID,
        name: String,
        color: String,
        emoji: String,
        schedule: Set<WeekDay>,
        isPinned: Bool,
        type: NewTrackerType,
        category: Category,
        previousCategoryId: UUID?
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.isPinned = isPinned
        self.type = type
        self.category = category
        self.previousCategoryId = previousCategoryId
    }

    init(trackerCoreData: TrackerCoreData) {
        self.id = trackerCoreData.id
        self.name = trackerCoreData.name
        self.color = trackerCoreData.color
        self.emoji = trackerCoreData.emoji
        self.schedule = trackerCoreData.schedule.toSetOfWeekDays
        self.isPinned = trackerCoreData.isPinned
        self.type = NewTrackerType(rawValue: Int(trackerCoreData.type)) ?? .event
        self.category = Category(categoryCoreData: trackerCoreData.category)
        self.previousCategoryId = trackerCoreData.previousCategoryId
    }

}

// MARK: - Equatable
extension Tracker: Equatable {

    static func == (lhs: Tracker, rhs: Tracker) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.color == rhs.color
            && lhs.emoji == rhs.emoji
            && lhs.schedule == rhs.schedule
            && lhs.isPinned == rhs.isPinned
            && lhs.type == rhs.type
            && lhs.category == rhs.category
    }

}

// MARK: - String extension
fileprivate extension String {

    var toSetOfWeekDays: Set<WeekDay> {
        Set(
            self.components(separatedBy: ", ")
                .map { WeekDay(rawValue: String($0))! }
        )
    }

}
