//
//  NewEventView.swift
//  Tracker
//

import UIKit

// MARK: - NewEventView
final class NewEventView: NewTrackerBaseView {

    // MARK: - Initializers
    init() {
        super.init(tableViewCells: [.category])
        title.text = "New event".localized()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
