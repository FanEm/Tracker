//
//  ScheduleView.swift
//  Tracker
//

import UIKit


// MARK: - ScheduleView
final class ScheduleView: ViewWithTableBaseView {

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setupUI() {
        title.text = L.Schedule.title
        tableView.register(ScheduleCell.self,forCellReuseIdentifier: ScheduleCell.reuseId)
        button.setTitle(L.Schedule.Button.done, for: .normal)
    }

}
