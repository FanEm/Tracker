//
//  ViewWithTableBaseView.swift
//  Tracker
//

import UIKit

// MARK: - ViewWithTableBaseView
class ViewWithTableBaseView: UIView {

    // MARK: - Public Properties
    var title: UILabel = {
        let label = UILabel()
        label.font = GlobalConstants.Font.sfPro16
        label.textColor = .trBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .trWhite
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .trGray
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var button: UIButton = BaseButton()

    // MARK: - Private Properties
    private enum Constants {
        enum Button {
            static let topAndBottomInset: CGFloat = 16
            static let trailingAndLeadingInsets: CGFloat = 20
        }
        enum TableView {
            static let topInset: CGFloat = 30
            static let bottomInset: CGFloat = 20
            static let trailingAndLeadingInsets: CGFloat = 16
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .trWhite
        addSubview(title)
        addSubview(tableView)
        addSubview(button)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(
                equalTo: topAnchor,
                constant: GlobalConstants.Title.inset
            ),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),

            tableView.topAnchor.constraint(
                equalTo: title.bottomAnchor,
                constant: Constants.TableView.topInset
            ),
            tableView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.TableView.trailingAndLeadingInsets
            ),
            trailingAnchor.constraint(
                equalTo: tableView.trailingAnchor,
                constant: Constants.TableView.trailingAndLeadingInsets
            ),

            button.topAnchor.constraint(
                equalTo: tableView.bottomAnchor,
                constant: Constants.Button.topAndBottomInset
            ),
            button.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.Button.trailingAndLeadingInsets
            ),
            trailingAnchor.constraint(
                equalTo: button.trailingAnchor,
                constant: Constants.Button.trailingAndLeadingInsets
            ),
            safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: button.bottomAnchor,
                constant: Constants.Button.topAndBottomInset
            )
        ])
    }
}
