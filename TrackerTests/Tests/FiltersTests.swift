//
//  FiltersTests.swift
//  TrackerTests
//

import XCTest
import SnapshotTesting
@testable import Tracker

// MARK: - FiltersTests
final class FiltersTests: XCTestCase {

    // MARK: - Light mode
    func testLightFiltersViewController() throws {
        let viewContoller = FiltersViewController()
        assertSnapshots(matching: viewContoller, as: image(mode: .light))
    }

    // MARK: - Dark mode
    func testDarkFiltersViewController() throws {
        let viewContoller = FiltersViewController()
        assertSnapshots(matching: viewContoller, as: image(mode: .dark))
    }

}
