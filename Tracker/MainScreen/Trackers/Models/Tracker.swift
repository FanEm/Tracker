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
}
