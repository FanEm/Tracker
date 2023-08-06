//
//  FiltersView.swift
//  Tracker
//

import UIKit

// MARK: - FiltersView
final class FiltersView: ViewWithTableBaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setpUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setpUpUI() {
        title.text = "Filters".localized()
        tableView.register(
            TitleTableViewCell.self,
            forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier
        )
        button.isHidden = true
    }
}
