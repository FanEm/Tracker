//
//  TextField.swift
//  Tracker
//

import UIKit

// MARK: - TextField
final class TextField: UITextField {

    // MARK: - Public Properties
    let padding: UIEdgeInsets

    // MARK: - Initializers
    init(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 40)) {
        self.padding = padding
        super.init(frame: .zero)
        backgroundColor = .trBackground
        layer.cornerRadius = GlobalConstants.cornerRadius
        clearButtonMode = .whileEditing
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -10, dy: 0)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
