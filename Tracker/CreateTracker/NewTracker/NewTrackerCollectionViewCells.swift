//
//  NewTrackerCollectionViewCells.swift
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
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private func selectCell() {
        backgroundColor = .trLightGray
        layer.masksToBounds = true
        layer.cornerRadius = GlobalConstants.cornerRadius
    }

    private func deselectCell() {
        backgroundColor = .trWhite
        layer.cornerRadius = 0
    }
}

// MARK: - NewTrackerColorViewCell
final class NewTrackerColorViewCell: UICollectionViewCell {

    // MARK: - Public Properties
    static let reuseIdentifier = "NewTrackerColorViewCell"

    // MARK: - Private Properties
    private enum Constants {
        static let inset: CGFloat = 6
        static let cornerRadius: CGFloat = 8
        
        enum SelectedCell {
            static let cornerRadius: CGFloat = 11
            static let borderWidth: CGFloat = 3
            static let opacity: CGFloat = 0.3
        }
    }

    private var color: UIColor?

    private var view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
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
    func configCell(hexString: String) {
        self.color = UIColor(hexString: hexString)
        view.backgroundColor = self.color
    }

    // MARK: - Private Methods
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.inset),
            view.topAnchor.constraint(equalTo: topAnchor, constant: Constants.inset),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.inset),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.inset)
        ])
    }

    private func selectCell() {
        layer.masksToBounds = true
        layer.cornerRadius = Constants.SelectedCell.cornerRadius
        layer.borderWidth = Constants.SelectedCell.borderWidth
        layer.borderColor = color?.withAlphaComponent(Constants.SelectedCell.opacity).cgColor
    }

    private func deselectCell() {
        layer.borderWidth = 0
    }
}
