//
//  NewHabitView.swift
//  Tracker
//

import UIKit

// MARK: - NewHabitView
final class NewHabitView: NewTrackerBaseView {

    // MARK: - Initializers
    init() {
        super.init(tableViewCells: [.category, .schedule])
        title.text = "New habit".localized()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
