//
//  TrackersTests.swift
//  TrackerTests
//

import XCTest
import SnapshotTesting
@testable import Tracker

// MARK: - TrackersTests
final class TrackersTests: XCTestCase {

    // MARK: - Light mode
    func testLightTrackersViewControllerEmpty() throws {
        let viewContoller = initViewControllers(
            trackerServiceState: .empty,
            recordServiceState: .noneDone
        )
        assertSnapshots(matching: viewContoller, as: image(mode: .light))
    }

    func testLightTrackersViewControllerOneSection() throws {
        let viewContoller = initViewControllers(
            trackerServiceState: .notEmpty(numberOfSections: 1),
            recordServiceState: .allDone
        )
        assertSnapshots(matching: viewContoller, as: image(mode: .light))
    }

    func testLightTrackersViewControllerTwoSections() throws {
        let viewContoller = initViewControllers(
            trackerServiceState: .notEmpty(numberOfSections: 2),
            recordServiceState: .noneDone
        )
        assertSnapshots(matching: viewContoller, as: image(mode: .light))
    }

    // MARK: - Dark mode
    func testDarkTrackersViewControllerEmpty() throws {
        let viewContoller = initViewControllers(
            trackerServiceState: .empty,
            recordServiceState: .noneDone
        )
        assertSnapshots(matching: viewContoller, as: image(mode: .dark))
    }

    func testDarkTrackersViewControllerOneSection() throws {
        let viewContoller = initViewControllers(
            trackerServiceState: .notEmpty(numberOfSections: 1),
            recordServiceState: .allDone
        )
        assertSnapshots(matching: viewContoller, as: image(mode: .dark))
    }

    func testDarkTrackersViewControllerTwoSections() throws {
        let viewContoller = initViewControllers(
            trackerServiceState: .notEmpty(numberOfSections: 2),
            recordServiceState: .noneDone
        )
        assertSnapshots(matching: viewContoller, as: image(mode: .dark))
    }

    // MARK: - Private Methods
    private func initViewControllers(
        trackerServiceState: FakeTrackerService.State,
        recordServiceState: FakeRecordService.State
    ) -> TrackersNavigationController {
        let trackersViewController = TrackersViewController()
        let trackersNavigationController = TrackersNavigationController()
        trackersNavigationController.viewControllers = [trackersViewController]
        let trackerServiceFake = FakeTrackerService(state: trackerServiceState)
        trackersViewController.setDate(date: date)
        let trackersPresenter = TrackersPresenter(
            trackerService: trackerServiceFake,
            recordService: FakeRecordService(
                trackers: trackerServiceFake.trackers,
                state: recordServiceState
            )
        )
        trackersViewController.presenter = trackersPresenter

        return trackersNavigationController
    }

}
