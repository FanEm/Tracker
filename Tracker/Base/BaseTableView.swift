//
//  BaseTableView.swift
//  Tracker
//

import UIKit

// MARK: - BaseTableView
final class BaseTableView: UITableView {

    // MARK: - Initializers
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .trWhite
        separatorStyle = .singleLine
        separatorColor = .trGray
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        tableFooterView = UIView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
