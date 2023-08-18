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
    
    init(id: UUID, name: String, color: String, emoji: String, schedule: Set<WeekDay>) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
    
    init(trackerCoreData: TrackerCoreData) {
        self.id = trackerCoreData.id
        self.name = trackerCoreData.name
        self.color = trackerCoreData.color
        self.emoji = trackerCoreData.emoji
        self.schedule = trackerCoreData.schedule.toSetOfWeekDays
    }

}


fileprivate extension String {

    var toSetOfWeekDays: Set<WeekDay> {
        Set(
            self.components(separatedBy: ", ")
                .map { WeekDay(rawValue: String($0))! }
        )
    }

}
