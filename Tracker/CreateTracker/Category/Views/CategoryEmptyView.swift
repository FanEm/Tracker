//
//  CategoryEmptyView.swift
//  Tracker
//

import UIKit

// MARK: - CategoryEmptyView
final class CategoryEmptyView: EmptyView {

    // MARK: - Public Properties
    var button: UIButton = {
        let button = BaseButton()
        button.setTitle(L.Category.Button.add, for: .normal)
        return button
    }()

    // MARK: - Private Properties
    private enum Constants {
        enum Button {
            static let bottomInset: CGFloat = 16
            static let trailingAndLeadingInsets: CGFloat = 20
        }
    }

    private var title: UILabel = {
        let label = UILabel()
        label.font = GlobalConstants.Font.sfPro16
        label.textColor = A.Colors.blackDynamic.color
        label.text = L.Category.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    init() {
        super.init(props: .category)
        addSubview(title)
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

            button.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.Button.trailingAndLeadingInsets
            ),
            safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: button.bottomAnchor,
                constant: Constants.Button.bottomInset
            ),
            trailingAnchor.constraint(
                equalTo: button.trailingAnchor,
                constant: Constants.Button.trailingAndLeadingInsets
            )
        ])
    }

}
