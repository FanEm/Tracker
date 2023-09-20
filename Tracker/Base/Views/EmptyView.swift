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
        image: A.Icons.Category.noCategories.image,
        label: L.Category.placeholder
    )

    static let statistics = EmptyViewProps(
        image: A.Icons.Statistics.noStatistic.image,
        label: L.Statistics.placeholder
    )

    static let trackers = EmptyViewProps(
        image: A.Icons.Trackers.noTrackers.image,
        label: L.Trackers.placeholder
    )

    static let search = EmptyViewProps(
        image: A.Icons.Trackers.Search.nothingFound.image,
        label: L.Trackers.Search.placeholder
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
