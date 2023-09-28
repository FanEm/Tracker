//
//  ScheduleTests.swift
//  TrackerTests
//

import XCTest
import SnapshotTesting
@testable import Tracker

// MARK: - ScheduleTests
final class ScheduleTests: XCTestCase {

    // MARK: - Light mode
    func testLightScheduleViewController() throws {
        let viewContoller = ScheduleViewController()
        assertSnapshots(matching: viewContoller, as: image(mode: .light))
    }

    // MARK: - Dark mode
    func testDarkScheduleViewController() throws {
        let viewContoller = ScheduleViewController()
        assertSnapshots(matching: viewContoller, as: image(mode: .dark))
    }

}
