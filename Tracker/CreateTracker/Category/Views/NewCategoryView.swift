//
//  NewCategoryView.swift
//  Tracker
//

import UIKit

// MARK: - NewCategoryView
final class NewCategoryView: UIView {

    // MARK: - Public Properties
    lazy var textField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter category name".localized(),
            attributes: [
                .foregroundColor: UIColor.trGray,
                .font: GlobalConstants.Font.sfPro17 ?? UIFont.systemFont(ofSize: 17)
            ]
        )
        textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        return textField
    }()

    lazy var button: UIButton = {
        let button = BaseButton()
        button.setTitleColor(.trPermWhite, for: .normal)
        button.setTitle("Done".localized(), for: .normal)
        button.backgroundColor = .trGray
        button.isEnabled = false
        return button
    }()

    // MARK: - Private Properties
    private enum Constants {
        enum Button {
            static let bottomInset: CGFloat = 16
            static let trailingAndLeadingInsets: CGFloat = 20
        }
        enum TextField {
            static let height: CGFloat = 75
            static let topInset: CGFloat = 24
            static let trailingAndLeadingInsets: CGFloat = 16
        }
    }
    
    private var title: UILabel = {
        let label = UILabel()
        label.text = "New category".localized()
        label.font = GlobalConstants.Font.sfPro16
        label.textColor = .trBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .trWhite
        addSubview(title)
        addSubview(textField)
        addSubview(button)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    @objc private func changeButtonState(isEnabled: Bool) {
        button.isEnabled = isEnabled
        button.backgroundColor = isEnabled ? .trBlack : .trGray
        button.setTitleColor(isEnabled ? .trWhite : .trPermWhite , for: .normal)
    }

    @objc private func textFieldChanged(_ textField: UITextField) {
        let isEnabled = textField.text != nil && !textField.text!.isEmpty
        changeButtonState(isEnabled: isEnabled)
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(
                equalTo: topAnchor,
                constant: GlobalConstants.Title.inset
            ),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),

            textField.topAnchor.constraint(
                equalTo: title.bottomAnchor,
                constant: Constants.TextField.topInset
            ),
            textField.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.TextField.trailingAndLeadingInsets
            ),
            trailingAnchor.constraint(
                equalTo: textField.trailingAnchor,
                constant: Constants.TextField.trailingAndLeadingInsets
            ),
            textField.heightAnchor.constraint(
                equalToConstant: Constants.TextField.height
            ),

            button.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.Button.trailingAndLeadingInsets
            ),
            trailingAnchor.constraint(
                equalTo: button.trailingAnchor,
                constant: Constants.Button.trailingAndLeadingInsets
            ),
            safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: button.bottomAnchor,
                constant: Constants.Button.bottomInset
            )
        ])
    }
}
