//
//  Tracker.swift
//  Tracker
//

import UIKit

struct Tracker: Codable {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: Set<WeekDay>
}
