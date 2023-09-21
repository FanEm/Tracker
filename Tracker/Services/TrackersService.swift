//
//  TrackersService.swift
//  Tracker
//

import UIKit

// MARK: - TrackersServiceProtocol
protocol TrackersServiceProtocol {
    var numberOfSections: Int { get }
    var dataProviderDelegate: TrackersDataProviderDelegate? { get set }

    func numberOfItemsInSection(_ section: Int) -> Int
    func tracker(at indexPath: IndexPath) -> Tracker?
    func deleteTracker(at indexPath: IndexPath)
    func editTracker(at indexPath: IndexPath, newTracker: Tracker)
    func pinTracker(at indexPath: IndexPath)
    func unpinTracker(at indexPath: IndexPath)
    func categoryTitle(at indexPath: IndexPath) -> String?
    func add(tracker: Tracker)
    func fetchTrackers(weekDay: WeekDay)
    func fetchTrackers(searchText: String, weekDay: WeekDay)
    func fetchCompletedTrackers(for date: Date)
    func fetchIncompletedTrackers(for date: Date)
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

    // swiftlint:disable force_cast
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

    func add(tracker: Tracker) {
        dataProvider?.add(tracker: tracker)
    }

    func editTracker(at indexPath: IndexPath, newTracker: Tracker) {
        dataProvider?.editTracker(at: indexPath, newTracker: newTracker)
    }

    func pinTracker(at indexPath: IndexPath) {
        dataProvider?.pinTracker(at: indexPath)
    }

    func unpinTracker(at indexPath: IndexPath) {
        dataProvider?.unpinTracker(at: indexPath)
    }

    func deleteTracker(at indexPath: IndexPath) {
        dataProvider?.deleteTracker(at: indexPath)
    }

    func fetchTrackers(weekDay: WeekDay) {
        dataProvider?.fetchTrackers(weekDay: weekDay)
    }

    func fetchTrackers(searchText: String, weekDay: WeekDay) {
        dataProvider?.fetchTrackers(searchText: searchText, weekDay: weekDay)
    }

    func fetchIncompletedTrackers(for date: Date) {
        dataProvider?.fetchIncompletedTrackers(for: date)
    }

    func fetchCompletedTrackers(for date: Date) {
        dataProvider?.fetchCompletedTrackers(for: date)
    }

}
