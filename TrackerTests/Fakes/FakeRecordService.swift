//
//  FakeRecordService.swift
//  TrackerTests
//

import Foundation
@testable import Tracker


// MARK: - FakeRecordService
final class FakeRecordService: RecordServiceProtocol {

    // MARK: - Public Properties
    enum State {
        case allDone
        case noneDone
    }
    var dataProviderDelegate: TrackerRecordDataProviderDelegate?
    let numberOfRecords: Int = 0
    
    // MARK: - Private Properties
    private let records: [TrackerRecord]
    private let state: State

    // MARK: - Initializers
    init(trackers: [[Tracker]], state: State) {
        self.state = state
        self.records = trackers
            .flatMap { $0 }
            .map { TrackerRecord(trackerId: $0.id, date: date) }
    }

    // MARK: - Public Methods
    func records(date: Date) -> [TrackerRecord] {
        switch state {
        case .allDone: return records.filter { $0.date == date }
        case .noneDone: return []
        }
    }

    func record(with trackerId: UUID, date: Date) -> TrackerRecord? {
        switch state {
        case .allDone: return records.filter { $0.trackerId == trackerId && $0.date == date }.first
        case .noneDone: return nil
        }
    }

    func recordsCount(with trackerId: UUID) -> Int {
        switch state {
        case .allDone: return records.filter { $0.trackerId == trackerId }.count
        case .noneDone: return 0
        }
    }

    // MARK: - Stubs
    func markTrackerAsCompleted(trackerId: UUID, date: Date) {}
    func markTrackerAsNotCompleted(trackerId: UUID, date: Date) {}
    func fetchRecords() {}

}
