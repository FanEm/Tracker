//
//  CategoryEmptyView.swift
//  Tracker
//

import UIKit

// MARK: - CategoryEmptyView
final class CategoryEmptyView: EmptyView {
    private enum Constants {
        enum Button {
            static let bottomInset: CGFloat = 16
            static let trailingAndLeadingInsets: CGFloat = 20
        }
    }

    init() {
        super.init(props: .category)
        addSubview(title)
        addSubview(button)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var title: UILabel = {
        let label = UILabel()
        label.font = GlobalConstants.Font.sfPro16
        label.textColor = .trBlack
        label.text = "Category".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var button: UIButton = {
        let button = BaseButton()
        button.setTitle("Add category".localized(), for: .normal)
        return button
    }()
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(
                equalTo: topAnchor,
                constant: GlobalConstants.Title.inset
            ),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            button.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.Button.trailingAndLeadingInsets
            ),
            safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: button.bottomAnchor,
                constant: Constants.Button.bottomInset
            ),
            trailingAnchor.constraint(
                equalTo: button.trailingAnchor,
                constant: Constants.Button.trailingAndLeadingInsets
            )
        ])
    }
}
