//
//  FakeTrackerService.swift
//  TrackerTests
//

import Foundation
@testable import Tracker

// MARK: - FakeTrackerService
final class FakeTrackerService: TrackersServiceProtocol {

    // MARK: - Public Properties
    enum State {
        case empty
        case notEmpty(numberOfSections: Int)
    }
    var numberOfSections: Int {
        switch state {
        case .empty: return 0
        case .notEmpty(let numberOfSections): return numberOfSections
        }
    }
    var dataProviderDelegate: TrackersDataProviderDelegate?
    let trackers: [[Tracker]] = [
        [
            Tracker(
                id: UUID(),
                name: "Пробежка",
                color: "#FF881E",
                emoji: "🥇",
                schedule: Set(WeekDay.allCases),
                isPinned: false,
                type: .habit,
                category: Category(id: UUID(), name: "Спорт"),
                previousCategoryId: nil
            )
        ], [
            Tracker(
                id: UUID(),
                name: "Английский",
                color: "#FF674D",
                emoji: "❤️",
                schedule: Set(WeekDay.allCases),
                isPinned: false,
                type: .event,
                category: Category(id: UUID(), name: "Обучение"),
                previousCategoryId: nil
            )
        ]
    ]

    // MARK: - Private Properties
    private let state: State

    // MARK: - Initializers
    init(state: State) {
        self.state = state
    }

    // MARK: - Public Methods
    func numberOfItemsInSection(_ section: Int) -> Int {
        switch state {
        case .empty: return 0
        case .notEmpty: return 1
        }
    }

    func tracker(at indexPath: IndexPath) -> Tracker? {
        tracker(indexPath: indexPath)
    }

    func categoryTitle(at indexPath: IndexPath) -> String? {
        tracker(indexPath: indexPath).category.name
    }

    // MARK: - Stubs
    func add(tracker: Tracker) {}
    func deleteTracker(at indexPath: IndexPath) {}
    func editTracker(at indexPath: IndexPath, newTracker: Tracker) {}
    func pinTracker(at indexPath: IndexPath) {}

    func unpinTracker(at indexPath: IndexPath) {}
    func fetchTrackers(weekDay: WeekDay) {}
    func fetchTrackers(searchText: String, weekDay: WeekDay) {}
    func fetchCompletedTrackers(for date: Date) {}
    func fetchIncompletedTrackers(for date: Date) {}

    // MARK: - Private Methods
    private func tracker(indexPath: IndexPath) -> Tracker {
        trackers[indexPath.section][indexPath.row]
    }

}
