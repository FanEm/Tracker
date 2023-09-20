//
//  StatisticsTests.swift
//  TrackerTests
//

import XCTest
import SnapshotTesting
@testable import Tracker


// MARK: - StatisticsTests
final class StatisticsTests: XCTestCase {

    // MARK: - Light mode
    func testLightStatisticsViewControllerEmpty() throws {
        let vc = initViewControllers(
            statisticsViewModelState: .empty
        )
        assertSnapshots(matching: vc, as: image(mode: .light))
    }

    func testLightStatisticsViewControllerAll() throws {
        let vc = initViewControllers(
            statisticsViewModelState: .all(count: 2)
        )
        assertSnapshots(matching: vc, as: image(mode: .light))
    }

    // MARK: - Dark mode
    func testDarkStatisticsViewControllerEmpty() throws {
        let vc = initViewControllers(
            statisticsViewModelState: .empty
        )
        assertSnapshots(matching: vc, as: image(mode: .dark))
    }

    func testDarkStatisticsViewControllerAll() throws {
        let vc = initViewControllers(
            statisticsViewModelState: .all(count: 2)
        )
        assertSnapshots(matching: vc, as: image(mode: .dark))
    }

    // MARK: - Private Methods
    private func initViewControllers(
        statisticsViewModelState: FakeStatisticsViewModel.State
    ) -> StatisticsNavigationController {
        let statisticsViewModel = FakeStatisticsViewModel(state: statisticsViewModelState)
        let statisticsViewController = StatisticsViewController(viewModel: statisticsViewModel)
        let statisticsNavigationController = StatisticsNavigationController()
        statisticsNavigationController.viewControllers = [statisticsViewController]

        return statisticsNavigationController
    }

}
