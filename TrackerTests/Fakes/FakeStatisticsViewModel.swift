//
//  FakeStatisticsViewModel.swift
//  TrackerTests
//

import Foundation
@testable import Tracker

// MARK: - FakeStatisticsViewModel
final class FakeStatisticsViewModel: StatisticsViewModelProtocol {

    // MARK: - Public Properties
    enum State {
        case empty
        case all(count: Int)
    }
    var analyticsService: AnalyticsService
    var onStatisticsChange: (() -> Void)?
    var statistics: Set<Statistic> {
        switch state {
        case .empty: return []
        case .all(let count): return [
            Statistic(type: .completed, count: count),
            Statistic(type: .perfectDays, count: count),
            Statistic(type: .average, count: count),
            Statistic(type: .bestPeriod, count: count)
        ]
        }
    }

    // MARK: - Public Properties
    private var state: State

    // MARK: - Initializers
    init(state: State) {
        self.analyticsService = AnalyticsService()
        self.state = state
    }

}
