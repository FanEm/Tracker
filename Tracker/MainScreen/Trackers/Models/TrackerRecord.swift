//
//  TrackerRecord.swift
//  Tracker
//

import Foundation
import UIKit

// MARK: - TrackerRecord
struct TrackerRecord: Codable {
    let trackerId: UUID
    let date: Date
}
