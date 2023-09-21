//
//  StatisticsView.swift
//  Tracker
//

import UIKit

// MARK: - StatisticsView
final class StatisticsView: UIView {

    // MARK: - Public Properties
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .trWhite
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(
            StatisticsTableViewCell.self,
            forCellReuseIdentifier: StatisticsTableViewCell.reuseIdentifier
        )
        tableView.contentInset = Constants.contentInset
        tableView.allowsSelection = false
        tableView.tableHeaderView = UIView(
            frame: .init(x: 0, y: 0,
                         width: tableView.frame.width,
                         height: Constants.headerHeight)
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Private Properties
    private enum Constants {
        static let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        static let headerHeight: CGFloat = 77
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .trWhite
        addSubview(tableView)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
    }

}
