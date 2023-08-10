//
//  TrackerCollectionViewCell.swift
//  Tracker
//

import UIKit

// MARK: - TrackerCollectionViewCell
final class TrackerCollectionViewCell: UICollectionViewCell {


    // MARK: - Public Properties
    static let reuseIdentifier = "TrackerCollectionViewCell"
    var tracker: Tracker? = nil
    var currentDate: Date = Date().stripTime()

    // MARK: - Private Properties
    private let storage = Storage.shared
    private enum Constants {
        static let leadingAndTrailingInsets: CGFloat = 12
        enum Label {
            static let fontSize: CGFloat = 12
            static let topInset: CGFloat = 8
            static let bottomInset: CGFloat = 12
        }
        enum Emoji {
            static let fontSize: CGFloat = 14
            static let heightAndWidth: CGFloat = 24
            static let cornerRadius: CGFloat = 12
            static let topInset: CGFloat = 12
        }
        enum QuantityLabel {
            static let height: CGFloat = 100
            static let topInset: CGFloat = 16
            static let bottomInset: CGFloat = 24
        }
        enum QuantityButton {
            static let topInset: CGFloat = 8
            static let bottomInset: CGFloat = 16
        }
    }
    
    private var doneCounter: Int = 0 {
        didSet {
            self.quantityLabel.text = "Days".localizedWithFormat(args: doneCounter)
        }
    }
    private var completedTrackers: [TrackerRecord] {
        get {
            return storage.completedTrackers
        }
        set {
            storage.completedTrackers = newValue
        }
    }

    private var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = GlobalConstants.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var label: UILabel = {
        let label = UILabel()
        label.font = .sfPro(ofSize: Constants.Label.fontSize)
        label.textColor = .trPermWhite
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .sfPro(ofSize: Constants.Emoji.fontSize)
        label.textAlignment = .center
        label.backgroundColor = .trTransperentWhite
        label.layer.cornerRadius = Constants.Emoji.cornerRadius
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var quantityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .sfPro(ofSize: Constants.Label.fontSize)
        label.textColor = .trBlack
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var quantityButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapOnQuantityButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var cardViewConstraints: [NSLayoutConstraint] {
        [
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
        ]
    }
    
    private var quantityViewConstraints: [NSLayoutConstraint] {
        [
            quantityView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            quantityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: quantityView.bottomAnchor),
        ]
    }
    
    private var quantityLabelConstraints: [NSLayoutConstraint] {
        [
            quantityLabel.leadingAnchor.constraint(
                equalTo: quantityView.leadingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            quantityLabel.widthAnchor.constraint(equalToConstant: Constants.QuantityLabel.height),
            quantityLabel.topAnchor.constraint(
                equalTo: quantityView.topAnchor,
                constant: Constants.QuantityLabel.topInset
            ),
            quantityView.bottomAnchor.constraint(
                equalTo: quantityLabel.bottomAnchor,
                constant: Constants.QuantityLabel.bottomInset
            ),
        ]
    }
    
    private var quantityButtonConstraints: [NSLayoutConstraint] {
        [
            quantityButton.topAnchor.constraint(
                equalTo: quantityView.topAnchor,
                constant: Constants.QuantityButton.topInset
            ),
            quantityView.trailingAnchor.constraint(
                equalTo: quantityButton.trailingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            quantityView.bottomAnchor.constraint(
                equalTo: quantityButton.bottomAnchor,
                constant: Constants.QuantityButton.bottomInset
            ),
        ]
    }
    
    private var emojiLabelConstraints: [NSLayoutConstraint] {
        [
            emojiLabel.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            emojiLabel.topAnchor.constraint(
                equalTo: cardView.topAnchor,
                constant: Constants.Emoji.topInset
            ),
            emojiLabel.heightAnchor.constraint(equalToConstant: Constants.Emoji.heightAndWidth),
            emojiLabel.widthAnchor.constraint(equalToConstant: Constants.Emoji.heightAndWidth),
        ]
    }
    
    private var labelConstraints: [NSLayoutConstraint] {
        [
            label.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            label.topAnchor.constraint(
                equalTo: emojiLabel.bottomAnchor,
                constant: Constants.Label.topInset
            ),
            cardView.trailingAnchor.constraint(
                equalTo: label.trailingAnchor,
                constant: Constants.leadingAndTrailingInsets
            ),
            cardView.bottomAnchor.constraint(
                equalTo: label.bottomAnchor,
                constant: Constants.Label.bottomInset
            )
        ]
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(cardView)
        cardView.addSubview(emojiLabel)
        cardView.addSubview(label)

        contentView.addSubview(quantityView)
        quantityView.addSubview(quantityLabel)
        quantityView.addSubview(quantityButton)

        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configCell(tracker: Tracker) {
        let color = UIColor(hexString: tracker.color)
        cardView.backgroundColor = color
        quantityButton.tintColor = color
        emojiLabel.text = tracker.emoji
        label.text = tracker.name
        doneCounter = doneCounterForTracker(tracker)
    
        if currentDate > Date().stripTime() {
            setImageForButton(image: .Trackers.plusButton, color: .trGray)
            quantityButton.isEnabled = false
            return
        }

        quantityButton.isEnabled = true
        if checkIfTrackerIsDone(tracker) {
            // TODO: заменить на doneButton, когда иконку поправят.
            setImageForButton(image: .Trackers.minusButton, color: color)
        } else {
            setImageForButton(image: .Trackers.plusButton, color: color)
        }
    }

    // MARK: - Private Methods
    private func setImageForButton(image: UIImage, color: UIColor) {
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        quantityButton.setImage(tintedImage, for: .normal)
    }

    private func completedTrackersWithout(_ tracker: Tracker) -> [TrackerRecord] {
        completedTrackers.filter { !($0.trackerId == tracker.id && $0.date == currentDate) }
    }

    private func checkIfTrackerIsDone(_ tracker: Tracker) -> Bool {
        completedTrackers.filter { $0.trackerId == tracker.id && $0.date == currentDate }.count == 1
    }

    private func doneCounterForTracker(_ tracker: Tracker) -> Int {
        completedTrackers.filter { $0.trackerId == tracker.id && $0.date <= currentDate }.count
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate(
            cardViewConstraints +
            quantityViewConstraints +
            quantityLabelConstraints +
            quantityButtonConstraints +
            emojiLabelConstraints +
            labelConstraints
        )
    }

    @objc private func tapOnQuantityButton() {
        guard let tracker else { return }
        let color = UIColor(hexString: tracker.color)
        let isDoneToday = checkIfTrackerIsDone(tracker)
        if isDoneToday {
            setImageForButton(image: .Trackers.plusButton, color: color)
            completedTrackers = completedTrackersWithout(tracker)
        } else {
            // TODO: заменить на doneButton, когда иконку поправят.
            setImageForButton(image: .Trackers.minusButton, color: color)
            completedTrackers.append(TrackerRecord(trackerId: tracker.id, date: currentDate))
        }
        doneCounter = doneCounterForTracker(tracker)
    }
}
