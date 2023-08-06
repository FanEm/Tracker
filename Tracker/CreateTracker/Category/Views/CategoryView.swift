//
//  CategoryView.swift
//  Tracker
//

import UIKit

// MARK: - CategoryView
final class CategoryView: ViewWithTableBaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setpUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setpUpUI() {
        title.text = "Category".localized()
        tableView.register(
            TitleTableViewCell.self,
            forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier
        )
        button.setTitle("Add category".localized(), for: .normal)
    }
}

