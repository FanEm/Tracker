//
//  NewHabitView.swift
//  Tracker
//

import UIKit

final class NewHabitView: NewTrackerBaseView {
    init() {
        super.init(tableViewCells: [.category, .schedule])
        title.text = "New habit".localized()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
