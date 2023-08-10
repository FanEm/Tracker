//
//  NewTrackerFooterView.swift
//  Tracker
//

import UIKit

// MARK: - NewTrackerFooterView
final class NewTrackerFooterView: UICollectionReusableView {

    // MARK: - Public Properties
    static let reuseIdentifier = "NewTrackerFooterView"
    weak var delegate: NewTrackerBaseViewDelegate?

    // MARK: - Private Properties
    private enum Constants {
        enum StackView {
            static let topAndBottomInset: CGFloat = 16
            static let leadingAndTrailingInsets: CGFloat = 20
            static let spacing: CGFloat = 8
        }
        enum Button {
            static let borderWidth: CGFloat = 1
        }
    }

    private lazy var cancelButton: UIButton = {
        let button = BaseButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = Constants.Button.borderWidth
        button.layer.borderColor = UIColor.trRed.cgColor
        button.setTitle("Cancel".localized(), for: .normal)
        button.setTitleColor(.trRed, for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()

    private lazy var createButton: UIButton = {
        let button = BaseButton()
        button.backgroundColor = .trGray
        button.setTitle("Create".localized(), for: .normal)
        button.setTitleColor(.trPermWhite, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.StackView.spacing
        stackView.addArrangedSubview(self.cancelButton)
        stackView.addArrangedSubview(self.createButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .trWhite
        addSubview(stackView)
        createAllFieldsFilledObserver()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func createAllFieldsFilledObserver() {
        return NotificationCenter.default.addObserver(self,
                                                      selector: #selector(changeCreateButtonState(notification:)),
                                                      name: .didAllFieldsFilled,
                                                      object: nil)
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.StackView.topAndBottomInset
            ),
            stackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.StackView.leadingAndTrailingInsets
            ),
            bottomAnchor.constraint(
                equalTo: stackView.bottomAnchor,
                constant: Constants.StackView.topAndBottomInset
            ),
            trailingAnchor.constraint(
                equalTo: stackView.trailingAnchor,
                constant: Constants.StackView.leadingAndTrailingInsets
            )
        ])
    }

    @objc private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }

    @objc private func didTapCreateButton() {
        delegate?.didTapCreateButton()
    }

    @objc private func changeCreateButtonState(notification: Notification) {
        guard let isEnabled = notification.object as? Bool else { return }
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .trBlack : .trGray
        createButton.setTitleColor(isEnabled ? .trWhite : .trPermWhite , for: .normal)
    }
}
