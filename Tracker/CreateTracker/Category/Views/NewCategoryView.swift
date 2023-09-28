//
//  NewCategoryView.swift
//  Tracker
//

import UIKit

// MARK: - NewCategoryView
final class NewCategoryView: UIView {

    // MARK: - Public Properties
    let mode: NewCategoryMode

    lazy var textField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: L.NewCategory.TextField.placeholder,
            attributes: [
                .foregroundColor: A.Colors.gray.color,
                .font: GlobalConstants.Font.sfPro17 ?? UIFont.systemFont(ofSize: 17)
            ]
        )
        textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        textField.text = textFieldText
        textField.becomeFirstResponder()
        return textField
    }()

    lazy var button: UIButton = {
        let button = BaseButton()
        button.setTitleColor(A.Colors.white.color, for: .normal)
        button.setTitle(L.NewCategory.Button.done, for: .normal)
        button.backgroundColor = A.Colors.gray.color
        button.isEnabled = false
        return button
    }()

    var indexPath: IndexPath? {
        switch mode {
        case .edit(_, let indexPath): return indexPath
        case .new: return nil
        }
    }

    lazy var buttonBottomAnchor = {
        self.safeAreaLayoutGuide.bottomAnchor.constraint(
            equalTo: self.button.bottomAnchor,
            constant: GlobalConstants.Button.bottomInset
        )
    }()

    // MARK: - Private Properties
    private enum Constants {
        enum Button {
            static let trailingAndLeadingInsets: CGFloat = 20
        }
        enum TextField {
            static let height: CGFloat = 75
            static let topInset: CGFloat = 24
            static let trailingAndLeadingInsets: CGFloat = 16
            static let maxLength: Int = 50
        }
    }

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.font = GlobalConstants.Font.sfPro16
        label.textColor = A.Colors.blackDynamic.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var titleText: String {
        switch mode {
        case .edit: return L.NewCategory.Edit.title
        case .new: return L.NewCategory.Create.title
        }
    }

    private var textFieldText: String {
        switch mode {
        case .edit(let name, _): return name
        case .new: return ""
        }
    }

    // MARK: - Initializers
    init(mode: NewCategoryMode) {
        self.mode = mode
        super.init(frame: .zero)
        backgroundColor = A.Colors.whiteDynamic.color
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
        button.backgroundColor = isEnabled ? A.Colors.blackDynamic.color : A.Colors.gray.color
        button.setTitleColor(isEnabled ? A.Colors.whiteDynamic.color : A.Colors.white.color, for: .normal)
    }

    @objc private func textFieldChanged(_ textField: UITextField) {
        var isEnabled = textField.text != nil && !textField.text!.isEmpty

        trimExtraCharacters(textField: textField)

        switch mode {
        case .new: break
        case .edit(let name, _):
            isEnabled = isEnabled && textField.text != name
        }
        changeButtonState(isEnabled: isEnabled)
    }

    private func trimExtraCharacters(textField: UITextField, maxLength: Int = Constants.TextField.maxLength) {
        if textField.text != nil, textField.text!.count > maxLength {
            textField.text = textField.text!.substring(to: maxLength)
        }
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
            buttonBottomAnchor
        ])
    }

}
