//
//  EmptyView.swift
//  Tracker
//

import UIKit

// MARK: - EmptyViewProps
struct EmptyViewProps {
    let image: UIImage
    let label: String

    static let category = EmptyViewProps(
        image: .CreateTracker.Category.NewCategory.nothingToShow,
        label: "Habits and events can be combined in meaning".localized()
    )

    static let statistics = EmptyViewProps(
        image: .Statistics.nothingToShow,
        label: "There is nothing to analyze yet".localized()
    )

    static let trackers = EmptyViewProps(
        image: .Trackers.nothingToShow,
        label: "What will we track".localized()
    )

    static let search = EmptyViewProps(
        image: .Trackers.nothingFound,
        label: "Nothing found".localized()
    )
}

// MARK: - EmptyView
class EmptyView: UIView {

    // MARK: - Private Properties
    private enum Constants {
        static let fontSize: CGFloat = 12
        static let labelInset: CGFloat = 8
    }

    private let props: EmptyViewProps

    private lazy var nothingToShowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.props.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nothingToShowLabel: UILabel = {
        let label = UILabel()
        label.text = self.props.label
        label.font = .sfPro(ofSize: Constants.fontSize)
        label.textColor = .trBlack
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    init(props: EmptyViewProps) {
        self.props = props

        super.init(frame: .zero)
        backgroundColor = .trWhite

        addSubview(nothingToShowImageView)
        addSubview(nothingToShowLabel)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            nothingToShowImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            nothingToShowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nothingToShowLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nothingToShowLabel.topAnchor.constraint(equalTo: nothingToShowImageView.bottomAnchor, constant: Constants.labelInset)
        ])
    }
}
