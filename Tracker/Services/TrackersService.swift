//
//  TrackersService.swift
//  Tracker
//

import Foundation
import UIKit


// MARK: - TrackersServiceProtocol
protocol TrackersServiceProtocol {
    var numberOfSections: Int { get }
    var dataProviderDelegate: TrackersDataProviderDelegate? { get set }

    func numberOfItemsInSection(_ section: Int) -> Int
    func tracker(at indexPath: IndexPath) -> Tracker?
    func categoryTitle(at indexPath: IndexPath) -> String?
    func add(tracker: Tracker, for categoryName: String)
    func markTrackerAsCompleted(trackerId: UUID, date: Date)
    func markTrackerAsNotCompleted(trackerId: UUID, date: Date)
    func fetchTrackers(weekDay: WeekDay)
    func fetchTrackers(searchText: String, weekDay: WeekDay)
    func records(date: Date) -> [TrackerRecord]
    func record(with trackerId: UUID, date: Date) -> TrackerRecord?
    func recordsCount(with trackerId: UUID) -> Int
}


// MARK: - TrackersService
final class TrackersService {

    // MARK: - Public Properties
    static var shared: TrackersServiceProtocol = TrackersService()

    var dataProviderDelegate: TrackersDataProviderDelegate? {
        didSet {
            dataProvider?.delegate = dataProviderDelegate
        }
    }

    // MARK: - Private Properties
    private let dataProvider: TrackersDataProvider?

    // MARK: - Initializers
    private init(dataProvider: TrackersDataProvider?) {
        self.dataProvider = dataProvider
    }

    private convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dataStore = appDelegate.dataStore
        self.init(dataProvider: TrackersDataProvider(dataStore: dataStore))
    }

}


// MARK: - TrackersServiceProtocol
extension TrackersService: TrackersServiceProtocol {

    // MARK: - Public Properties
    var numberOfSections: Int {
        dataProvider?.numberOfSections ?? 0
    }

    // MARK: - Public Methods
    func numberOfItemsInSection(_ section: Int) -> Int {
        dataProvider?.numberOfItemsInSection(section) ?? 0
    }

    func tracker(at indexPath: IndexPath) -> Tracker? {
        guard let trackerCoreData = dataProvider?.tracker(at: indexPath) else { return nil }
        return Tracker(trackerCoreData: trackerCoreData)
    }

    func categoryTitle(at indexPath: IndexPath) -> String? {
        dataProvider?.categoryTitle(at: indexPath)
    }

    func add(tracker: Tracker, for categoryName: String) {
        dataProvider?.add(tracker: tracker, for: categoryName)
    }

    func markTrackerAsCompleted(trackerId: UUID, date: Date) {
        dataProvider?.markTrackerAsCompleted(trackerId: trackerId, date: date)
    }

    func markTrackerAsNotCompleted(trackerId: UUID, date: Date) {
        dataProvider?.markTrackerAsNotCompleted(trackerId: trackerId, date: date)
    }

    func fetchTrackers(weekDay: WeekDay) {
        dataProvider?.fetchTrackers(weekDay: weekDay)
    }

    func fetchTrackers(searchText: String, weekDay: WeekDay) {
        dataProvider?.fetchTrackers(searchText: searchText, weekDay: weekDay)
    }

    func records(date: Date) -> [TrackerRecord] {
        let trackerRecordsCoreData = dataProvider?.records(date: date) ?? []
        return trackerRecordsCoreData.map { TrackerRecord(trackerRecordCoreData: $0) }
    }

    func record(with trackerId: UUID, date: Date) -> TrackerRecord? {
        guard let trackerRecordCoreData = dataProvider?.record(with: trackerId, date: date) else { return nil }
        return TrackerRecord(trackerRecordCoreData: trackerRecordCoreData)
    }

    func recordsCount(with trackerId: UUID) -> Int {
        dataProvider?.recordsCount(with: trackerId) ?? 0
    }

}
