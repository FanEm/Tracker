//
//  GlobalConstants.swift
//  Tracker
//

import UIKit

// MARK: - GlobalConstants
enum GlobalConstants {

    static let cornerRadius: CGFloat = 16

    enum TableViewCell {
        static let separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let height: CGFloat = 75
    }

    enum Button {
        static let edgeInsets = UIEdgeInsets(top: 19, left: 32, bottom: 19, right: 32)
        static let bottomInset: CGFloat = 16
    }

    enum Font {
        static let sfPro16 = UIFont.sfPro(ofSize: 16)
        static let sfPro17 = UIFont.sfPro(ofSize: 17)
    }

    enum Title {
        static let inset: CGFloat = 27
    }

    enum TextField {
        static let maxLength: Int = 38
    }

}
