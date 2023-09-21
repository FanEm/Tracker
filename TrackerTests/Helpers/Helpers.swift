//
//  Helpers.swift
//  TrackerTests
//

import SnapshotTesting
import UIKit
@testable import Tracker

func image(mode: UIUserInterfaceStyle) -> [Snapshotting<UIViewController, UIImage>] {
    [.image(traits: .init(userInterfaceStyle: mode))]
}

let date = Date(timeIntervalSince1970: 1694351542).stripTime()
