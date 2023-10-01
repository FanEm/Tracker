//
//  StatisticsViewModel.swift
//  Tracker
//

import Foundation

// MARK: - StatisticsViewModelProtocol
protocol StatisticsViewModelProtocol {
    var onStatisticsChange: (() -> Void)? { get set }
    var statistics: Set<Statistic> { get }
    var analyticsService: AnalyticsService { get }
}

// MARK: - StatisticsViewModel
final class StatisticsViewModel: StatisticsViewModelProtocol {

    // MARK: - Public Properties
    let analyticsService: AnalyticsService
    var onStatisticsChange: (() -> Void)?
    private(set) var statistics: Set<Statistic> = [] {
        didSet {
            self.onStatisticsChange?()
        }
    }

    // MARK: - Private Properties
    private var recordService: RecordServiceProtocol

    // MARK: - Initializers
    init(recordService: RecordServiceProtocol) {
        self.analyticsService = AnalyticsService()
        self.recordService = recordService
        self.recordService.dataProviderDelegate = self
        fetchRecords()
    }

    convenience init() {
        self.init(recordService: RecordService.shared)
    }

    // MARK: - Private Methods
    private func fetchRecords() {
        recordService.fetchRecords()
        addCompletedStatistic(numberOfRecords: recordService.numberOfRecords)
    }

    private func updateCompletedStatistic(numberOfRecords: Int) {
        if let completedStatistic = statistics.first(where: { $0.type == .completed }) {
            statistics.remove(completedStatistic)
            removeAnotherStatistic()
        }
        addCompletedStatistic(numberOfRecords: numberOfRecords)
    }

    private func addCompletedStatistic(numberOfRecords: Int) {
        guard numberOfRecords > 0 else { return }

        statistics.insert(Statistic(type: .completed, count: numberOfRecords))
        addAnotherStatistic()
    }

    // TODO: Заглушка. Добавить другие виды статистики
    private func addAnotherStatistic() {
        statistics.insert(Statistic(type: .average, count: 0))
        statistics.insert(Statistic(type: .bestPeriod, count: 0))
        statistics.insert(Statistic(type: .perfectDays, count: 0))
    }

    private func removeAnotherStatistic() {
        statistics.remove(Statistic(type: .average, count: 0))
        statistics.remove(Statistic(type: .bestPeriod, count: 0))
        statistics.remove(Statistic(type: .perfectDays, count: 0))
    }

}

// MARK: - TrackerRecordDataProviderDelegate
extension StatisticsViewModel: TrackerRecordDataProviderDelegate {

    func didUpdate(_ update: StoreUpdate) {
        let numberOfRecords = recordService.numberOfRecords
        updateCompletedStatistic(numberOfRecords: numberOfRecords)
    }

}
