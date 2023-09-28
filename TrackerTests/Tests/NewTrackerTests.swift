//
//  NewTrackerTests.swift
//  TrackerTests
//

import XCTest
import SnapshotTesting
@testable import Tracker

// MARK: - NewTrackerTests
final class NewTrackerTests: XCTestCase {

    // MARK: - Light mode
    func testLightNewTrackerViewControllerHabit() throws {
        let viewContoller = initViewController(type: .habit)
        assertSnapshots(matching: viewContoller, as: image(mode: .light))
    }

    func testLightNewTrackerViewControllerEvent() throws {
        let viewContoller = initViewController(type: .event, isFilled: true)
        assertSnapshots(matching: viewContoller, as: image(mode: .light))
    }

    // MARK: - Dark mode
    func testDarkNewTrackerViewControllerHabit() throws {
        let viewContoller = initViewController(type: .habit, isFilled: true)
        assertSnapshots(matching: viewContoller, as: image(mode: .dark))
    }

    func testDarkNewTrackerViewControllerEvent() throws {
        let viewContoller = initViewController(type: .event)
        assertSnapshots(matching: viewContoller, as: image(mode: .dark))
    }

    // MARK: - Private Methods
    private func initViewController(
        type: NewTrackerType,
        isFilled: Bool = false
    ) -> NewTrackerViewController {
        let presenter = NewTrackerPresenter(type: type)
        let viewController = NewTrackerViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        if isFilled {
            let tracker = Tracker(
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
            presenter.configureNewTrackerModel(tracker: tracker)
        }
        return viewController
    }

}
