//
//  ScheduleView.swift
//  Tracker
//

import UIKit

// MARK: - ScheduleView
final class ScheduleView: ViewWithTableBaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setpUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setpUpUI() {
        title.text = "Schedule".localized()
        tableView.register(ScheduleCell.self,forCellReuseIdentifier: ScheduleCell.reuseId)
        button.setTitle("Done".localized(), for: .normal)
    }
}
