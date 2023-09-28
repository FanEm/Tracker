//
//  NewTrackerEmojiViewCell.swift
//  Tracker
//

import UIKit

// MARK: - NewTrackerEmojiViewCell
final class NewTrackerEmojiViewCell: UICollectionViewCell {

    // MARK: - Public Properties
    static let reuseIdentifier = "NewTrackerEmojiViewCell"

    // MARK: - Private Properties
    private enum Constants {
        static let fontSize: CGFloat = 32
    }

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .sfPro(ofSize: Constants.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods
    override var isSelected: Bool {
        didSet {
            isSelected ? selectCell() : deselectCell()
        }
    }

    // MARK: - Public Methods
    func configCell(emoji: String) {
        titleLabel.text = emoji
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func selectCell() {
        backgroundColor = A.Colors.grayLight.color
        layer.masksToBounds = true
        layer.cornerRadius = GlobalConstants.cornerRadius
    }

    private func deselectCell() {
        backgroundColor = A.Colors.whiteDynamic.color
        layer.cornerRadius = 0
    }

}
