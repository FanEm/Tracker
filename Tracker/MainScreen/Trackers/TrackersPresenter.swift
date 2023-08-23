//
//  TrackersPresenter.swift
//  Tracker
//

import Foundation


// MARK: - TrackersPresenterProtocol
protocol TrackersPresenterProtocol: AnyObject {
    var view: TrackersViewControllerProtocol? { get set }
    var numberOfSections: Int { get }
    
    func viewDidLoad()
    func fetchTrackers(date: Date)
    func fetchTrackers(searchText: String?)
    func numberOfItemsInSection(_ section: Int) -> Int
    func tracker(at indexPath: IndexPath) -> Tracker?
    func categoryTitle(at indexPath: IndexPath) -> String?
    
    func isTrackerCompleted(_ tracker: Tracker) -> Bool
    func completeCounterForTracker(_ tracker: Tracker) -> Int
    func markTrackerAsNotCompleted(_ tracker: Tracker)
    func markTrackerAsCompleted(_ tracker: Tracker)
}


// MARK: - TrackersPresenterProtocol
final class TrackersPresenter: TrackersPresenterProtocol {

    // MARK: - Public Properties
    weak var view: TrackersViewControllerProtocol?
    var numberOfSections: Int {
        trackerService?.numberOfSections ?? 0
    }

    // MARK: - Private Properties
    private var trackerService: TrackerServiceProtocol?
    private var currentDate = Date().stripTime()

    init(trackerService: TrackerServiceProtocol) {
        self.trackerService = trackerService
        self.trackerService?.dataProviderDelegate = self
    }

    // MARK: - Public Methods
    func viewDidLoad() {
        trackerService?.fetchTrackers(weekDay: currentDate.dayOfTheWeek())
    }

    func fetchTrackers(date: Date) {
        currentDate = date
        let weekDay = currentDate.dayOfTheWeek()
        trackerService?.fetchTrackers(weekDay: weekDay)
    }

    func fetchTrackers(searchText: String?) {
        guard let searchText else { return }
        let weekDay = currentDate.dayOfTheWeek()
        trackerService?.fetchTrackers(searchText: searchText, weekDay: weekDay)
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        trackerService?.numberOfItemsInSection(section) ?? 0
    }

    func tracker(at indexPath: IndexPath) -> Tracker? {
        trackerService?.tracker(at: indexPath)
    }

    func categoryTitle(at indexPath: IndexPath) -> String? {
        trackerService?.categoryTitle(at: indexPath)
    }

    func isTrackerCompleted(_ tracker: Tracker) -> Bool {
        trackerService?.record(with: tracker.id, date: currentDate) != nil
    }

    func completeCounterForTracker(_ tracker: Tracker) -> Int {
        trackerService?.recordsCount(with: tracker.id) ?? 0
    }

    func markTrackerAsNotCompleted(_ tracker: Tracker) {
        trackerService?.markTrackerAsNotCompleted(trackerId: tracker.id, date: currentDate)
    }

    func markTrackerAsCompleted(_ tracker: Tracker) {
        trackerService?.markTrackerAsCompleted(trackerId: tracker.id, date: currentDate)
    }

}


// MARK: - DataProviderDelegate
extension TrackersPresenter: DataProviderDelegate {

    func didUpdate(_ update: TrackerStoreUpdate) {
        view?.reloadCollectionView()
    }

}
