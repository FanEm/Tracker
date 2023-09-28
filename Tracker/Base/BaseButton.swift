//
//  BaseButton.swift
//  Tracker
//

import UIKit

// MARK: - BaseButton
final class BaseButton: UIButton {

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = GlobalConstants.cornerRadius
        contentEdgeInsets = GlobalConstants.Button.edgeInsets
        titleLabel?.font = GlobalConstants.Font.sfPro16
        setTitleColor(A.Colors.whiteDynamic.color, for: .normal)
        layer.masksToBounds = true
        backgroundColor = A.Colors.blackDynamic.color
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
