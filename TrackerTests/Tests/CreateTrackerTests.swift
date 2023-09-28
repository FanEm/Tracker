//
//  CreateTrackerTests.swift
//  TrackerTests
//

import XCTest
import SnapshotTesting
@testable import Tracker

// MARK: - CreateTrackerTests
final class CreateTrackerTests: XCTestCase {

    // MARK: - Light mode
    func testLightCreateTrackerViewController() throws {
        let viewContoller = CreateTrackerViewController()
        assertSnapshots(matching: viewContoller, as: image(mode: .light))
    }

    // MARK: - Dark mode
    func testDarkCreateTrackerViewController() throws {
        let viewContoller = CreateTrackerViewController()
        assertSnapshots(matching: viewContoller, as: image(mode: .dark))
    }

}
