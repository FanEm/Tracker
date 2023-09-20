//
//  TrackerRecord.swift
//  Tracker
//

import UIKit


// MARK: - TrackerRecord
struct TrackerRecord: Codable {

    let trackerId: UUID
    let date: Date
    
    init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
    
    init(trackerRecordCoreData: TrackerRecordCoreData) {
        self.trackerId = trackerRecordCoreData.trackerId
        self.date = trackerRecordCoreData.date
    }

}
