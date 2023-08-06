//
//  CreateTrackerView.swift
//  Tracker
//

import UIKit

// MARK: - CreateTrackerViewDelegate
protocol CreateTrackerViewDelegate: AnyObject {
    func didTapHabitButton()
    func didTapEventButton()
}

// MARK: - CreateTrackerView
final class CreateTrackerView: UIView {
    private enum Constants {
        static let topInset: CGFloat = 250
        static let bottomInset: CGFloat = 16
        static let leadingAndTrailingInset: CGFloat = 20
    }

    weak var delegate: CreateTrackerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .trWhite
        addSubview(title)
        addSubview(habitButton)
        addSubview(eventButton)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var habitButton: UIButton = {
        let button = BaseButton()
        button.setTitle("Habit".localized(), for: .normal)
        button.addTarget(self, action: #selector(tapOnHabitButton), for: .touchUpInside)
        return button
    }()

    private lazy var eventButton: UIButton = {
        let button = BaseButton()
        button.setTitle("Event".localized(), for: .normal)
        button.addTarget(self, action: #selector(tapOnEventButton), for: .touchUpInside)
        return button
    }()

    private var title: UILabel = {
        let label = UILabel()
        label.text = "Create tracker".localized()
        label.font = GlobalConstants.Font.sfPro16
        label.textColor = .trBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(
                equalTo: topAnchor,
                constant: GlobalConstants.Title.inset
            ),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            habitButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.leadingAndTrailingInset
            ),
            trailingAnchor.constraint(
                equalTo: habitButton.trailingAnchor,
                constant: Constants.leadingAndTrailingInset
            ),
            habitButton.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.topInset
            ),
            eventButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.leadingAndTrailingInset
            ),
            trailingAnchor.constraint(
                equalTo: eventButton.trailingAnchor,
                constant: Constants.leadingAndTrailingInset
            ),
            eventButton.topAnchor.constraint(
                equalTo: habitButton.bottomAnchor,
                constant: Constants.bottomInset
            )
        ])
    }
    
    @objc private func tapOnHabitButton() {
        self.delegate?.didTapHabitButton()
    }
    
    @objc private func tapOnEventButton() {
        self.delegate?.didTapEventButton()
    }
}
