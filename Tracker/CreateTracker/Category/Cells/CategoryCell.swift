//
//  CategoryCell.swift
//  Tracker
//

import UIKit


// MARK: - CategoryCell
final class CategoryCell: TitleTableViewCell {

    // MARK: - Public Properties
    static let reuseId = "CategoryCell"

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configCell(label: String, isCategorySelected: Bool) {
        super.configCell(label: label)
        self.accessoryType = isCategorySelected ? .checkmark : .none
    }

}
