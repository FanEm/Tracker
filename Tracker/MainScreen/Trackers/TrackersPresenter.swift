//
//  TrackersPresenter.swift
//  Tracker
//

import Foundation

// MARK: - TrackersPresenterProtocol
protocol TrackersPresenterProtocol: AnyObject {
    var view: TrackersViewControllerProtocol? { get set }
    var analyticsService: AnalyticsService { get }
    var numberOfSections: Int { get }

    func viewDidLoad()
    func fetchTrackers(date: Date)
    func fetchTrackers(searchText: String?)
    func fetchCompletedTrackers(for date: Date)
    func fetchIncompletedTrackers(for date: Date)
    func numberOfItemsInSection(_ section: Int) -> Int
    func tracker(at indexPath: IndexPath) -> Tracker?
    func pinTracker(at indexPath: IndexPath)
    func unpinTracker(at indexPath: IndexPath)
    func deleteTracker(at indexPath: IndexPath)
    func editTracker(at indexPath: IndexPath, newTracker: Tracker)
    func categoryTitle(at indexPath: IndexPath) -> String?

    func isTrackerCompleted(_ tracker: Tracker) -> Bool
    func completeCounterForTracker(_ tracker: Tracker) -> Int
    func markTrackerAsNotCompleted(_ tracker: Tracker)
    func markTrackerAsCompleted(_ tracker: Tracker)
}

// MARK: - TrackersPresenterProtocol
final class TrackersPresenter: TrackersPresenterProtocol {

    // MARK: - Public Properties
    let analyticsService: AnalyticsService
    weak var view: TrackersViewControllerProtocol?
    var numberOfSections: Int {
        trackerService?.numberOfSections ?? 0
    }

    // MARK: - Private Properties
    private var trackerService: TrackersServiceProtocol?
    private var recordService: RecordServiceProtocol?
    private var currentDate = Date().stripTime()

    init(trackerService: TrackersServiceProtocol, recordService: RecordServiceProtocol) {
        self.analyticsService = AnalyticsService()
        self.trackerService = trackerService
        self.recordService = recordService
        self.trackerService?.dataProviderDelegate = self
    }

    // MARK: - Public Methods
    func viewDidLoad() {
        trackerService?.fetchTrackers(weekDay: currentDate.dayOfTheWeek)
    }

    func fetchTrackers(date: Date) {
        currentDate = date
        let weekDay = currentDate.dayOfTheWeek
        trackerService?.fetchTrackers(weekDay: weekDay)
    }

    func fetchTrackers(searchText: String?) {
        guard let searchText else { return }
        let weekDay = currentDate.dayOfTheWeek
        trackerService?.fetchTrackers(searchText: searchText, weekDay: weekDay)
    }

    func fetchCompletedTrackers(for date: Date) {
        trackerService?.fetchCompletedTrackers(for: date)
    }

    func fetchIncompletedTrackers(for date: Date) {
        trackerService?.fetchIncompletedTrackers(for: date)
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        trackerService?.numberOfItemsInSection(section) ?? 0
    }

    func tracker(at indexPath: IndexPath) -> Tracker? {
        trackerService?.tracker(at: indexPath)
    }

    func pinTracker(at indexPath: IndexPath) {
        trackerService?.pinTracker(at: indexPath)
        analyticsService.didClickPinTracker()
    }

    func unpinTracker(at indexPath: IndexPath) {
        trackerService?.unpinTracker(at: indexPath)
        analyticsService.didClickUnpinTracker()
    }

    func deleteTracker(at indexPath: IndexPath) {
        trackerService?.deleteTracker(at: indexPath)
        analyticsService.didClickDeleteTracker()
    }

    func editTracker(at indexPath: IndexPath, newTracker: Tracker) {
        trackerService?.editTracker(at: indexPath, newTracker: newTracker)
    }

    func categoryTitle(at indexPath: IndexPath) -> String? {
        trackerService?.categoryTitle(at: indexPath)
    }

    func isTrackerCompleted(_ tracker: Tracker) -> Bool {
        recordService?.record(with: tracker.id, date: currentDate) != nil
    }

    func completeCounterForTracker(_ tracker: Tracker) -> Int {
        recordService?.recordsCount(with: tracker.id) ?? 0
    }

    func markTrackerAsNotCompleted(_ tracker: Tracker) {
        recordService?.markTrackerAsNotCompleted(trackerId: tracker.id, date: currentDate)
        analyticsService.didClickIncompleteTracker()
    }

    func markTrackerAsCompleted(_ tracker: Tracker) {
        recordService?.markTrackerAsCompleted(trackerId: tracker.id, date: currentDate)
        analyticsService.didClickCompleteTracker()
    }

}

// MARK: - TrackersDataProviderDelegate
extension TrackersPresenter: TrackersDataProviderDelegate {

    func didUpdate(_ update: StoreUpdate) {
        view?.reloadCollectionView(searchText: nil)
    }

}
