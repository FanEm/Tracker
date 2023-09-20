//
//  FiltersView.swift
//  Tracker
//

import UIKit

// MARK: - FiltersView
final class FiltersView: ViewWithTableBaseView {

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setpUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setpUpUI() {
        title.text = L.Filters.title
        tableView.register(
            TitleTableViewCell.self,
            forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier
        )
        button.isHidden = true
    }

}
