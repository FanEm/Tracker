//
//  BaseSectionTitleView.swift
//  Tracker
//

import UIKit

// MARK: - BaseSectionTitleView
final class BaseSectionTitleView: UICollectionReusableView {

    // MARK: - Public Properties
    static let reuseIdentifier = "BaseSectionTitleView"

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .sfPro(ofSize: Constants.fontSize, withStyle: .bold)
        label.textColor = .trBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Private Properties
    private enum Constants {
        static let fontSize: CGFloat = 19
        enum Label {
            static let leadingAndTrailingInsets: CGFloat = 28
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(titleLabel)

        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.Label.leadingAndTrailingInsets
            ),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: Constants.Label.leadingAndTrailingInsets
            )
        ])
    }
}
