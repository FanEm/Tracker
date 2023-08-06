//
//  NewTrackerCollectionViewCells.swift
//  Tracker
//

import UIKit

// MARK: - NewTrackerEmojiViewCell
final class NewTrackerEmojiViewCell: UICollectionViewCell {
    private enum Constants {
        static let fontSize: CGFloat = 32
    }

    static let reuseIdentifier = "NewTrackerEmojiViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configCell(emoji: String) {
        titleLabel.text = emoji
    }

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .sfPro(ofSize: Constants.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

// MARK: - NewTrackerColorViewCell
final class NewTrackerColorViewCell: UICollectionViewCell {
    private enum Constants {
        static let inset: CGFloat = 5
        static let cornerRadius: CGFloat = 8
    }

    static let reuseIdentifier = "NewTrackerColorViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configCell(color: UIColor) {
        view.backgroundColor = color
    }

    private var view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.inset),
            view.topAnchor.constraint(equalTo: topAnchor, constant: Constants.inset),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.inset),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.inset)
        ])
    }
}
