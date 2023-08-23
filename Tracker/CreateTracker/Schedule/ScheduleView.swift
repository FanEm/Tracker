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
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setUpUI() {
        title.text = "Schedule".localized()
        tableView.register(ScheduleCell.self,forCellReuseIdentifier: ScheduleCell.reuseId)
        button.setTitle("Done".localized(), for: .normal)
    }
}
