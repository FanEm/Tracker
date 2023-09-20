//
//  NewHabitView.swift
//  Tracker
//

import UIKit

// MARK: - NewHabitView
final class NewHabitView: NewTrackerBaseView {

    // MARK: - Initializers
    init(mode: NewTrackerMode) {
        super.init(tableViewCells: [.category, .schedule])
        title.text = titleText(mode: mode)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func titleText(mode: NewTrackerMode) -> String {
        switch mode {
        case .new: return L.NewTracker.Habit.create
        case .edit: return L.NewTracker.Habit.edit
        }
    }

}
