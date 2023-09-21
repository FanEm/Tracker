//
//  RecordService.swift
//  Tracker
//

import UIKit

// MARK: - RecordServiceProtocol
protocol RecordServiceProtocol {
    var dataProviderDelegate: TrackerRecordDataProviderDelegate? { get set }
    var numberOfRecords: Int { get }

    func markTrackerAsCompleted(trackerId: UUID, date: Date)
    func markTrackerAsNotCompleted(trackerId: UUID, date: Date)
    func records(date: Date) -> [TrackerRecord]
    func record(with trackerId: UUID, date: Date) -> TrackerRecord?
    func recordsCount(with trackerId: UUID) -> Int

    func fetchRecords()
}

// MARK: - RecordService
final class RecordService {

    // MARK: - Public Properties
    static var shared: RecordServiceProtocol = RecordService()
    var dataProviderDelegate: TrackerRecordDataProviderDelegate? {
        didSet {
            dataProvider?.delegate = dataProviderDelegate
        }
    }

    // MARK: - Private Properties
    private let dataProvider: TrackerRecordDataProvider?

    // MARK: - Initializers
    private init(dataProvider: TrackerRecordDataProvider?) {
        self.dataProvider = dataProvider
    }

    // swiftlint:disable force_cast
    private convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dataStore = appDelegate.dataStore
        self.init(dataProvider: TrackerRecordDataProvider(dataStore: dataStore))
    }

}

// MARK: - RecordServiceProtocol
extension RecordService: RecordServiceProtocol {

    // MARK: - Public Properties
    var numberOfRecords: Int {
        dataProvider?.numberOfRecords ?? 0
    }

    // MARK: - Public Methods
    func markTrackerAsCompleted(trackerId: UUID, date: Date) {
        dataProvider?.markTrackerAsCompleted(trackerId: trackerId, date: date)
    }

    func markTrackerAsNotCompleted(trackerId: UUID, date: Date) {
        dataProvider?.markTrackerAsNotCompleted(trackerId: trackerId, date: date)
    }

    func records(date: Date) -> [TrackerRecord] {
        let trackerRecordsCoreData = dataProvider?.records(date: date) ?? []
        return trackerRecordsCoreData.map { TrackerRecord(trackerRecordCoreData: $0) }
    }

    func record(with trackerId: UUID, date: Date) -> TrackerRecord? {
        guard let trackerRecordCoreData = dataProvider?.record(with: trackerId, date: date) else {
            return nil
        }
        return TrackerRecord(trackerRecordCoreData: trackerRecordCoreData)
    }

    func recordsCount(with trackerId: UUID) -> Int {
        dataProvider?.recordsCount(with: trackerId) ?? 0
    }

    func fetchRecords() {
        dataProvider?.fetchRecords()
    }

}
