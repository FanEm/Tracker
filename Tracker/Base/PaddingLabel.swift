//
//  PaddingLabel.swift
//  Tracker
//

import UIKit

// MARK: - PaddingLabel
final class PaddingLabel: UILabel {

    // MARK: - Public Properties
    let padding: UIEdgeInsets

    // MARK: - Initializers
    init(padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)) {
        self.padding = padding
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (padding.left + padding.right)
        }
    }

}
