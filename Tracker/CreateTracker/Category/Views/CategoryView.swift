//
//  CategoryView.swift
//  Tracker
//

import UIKit

// MARK: - CategoryView
final class CategoryView: ViewWithTableBaseView {

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
        title.text = "Category".localized()
        tableView.register(
            CategoryCell.self,
            forCellReuseIdentifier: CategoryCell.reuseId
        )
        button.setTitle("Add category".localized(), for: .normal)
    }
}

