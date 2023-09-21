//
//  NewEventView.swift
//  Tracker
//

import UIKit

// MARK: - NewEventView
final class NewEventView: NewTrackerBaseView {

    // MARK: - Initializers
    init(mode: NewTrackerMode) {
        super.init(tableViewCells: [.category])
        title.text = titleText(mode: mode)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func titleText(mode: NewTrackerMode) -> String {
        switch mode {
        case .new: return L.NewTracker.Event.create
        case .edit: return L.NewTracker.Event.edit
        }
    }

}
