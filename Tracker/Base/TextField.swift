//
//  TextField.swift
//  Tracker
//

import UIKit

// MARK: - TextField
final class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 40)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .trBackground
        layer.cornerRadius = GlobalConstants.cornerRadius
        clearButtonMode = .whileEditing
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
