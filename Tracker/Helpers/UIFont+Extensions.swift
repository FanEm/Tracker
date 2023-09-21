//
//  UIFont+Extensions.swift
//  Tracker
//

import UIKit

extension UIFont {

    static func sfPro(
        ofSize fontSize: CGFloat,
        withStyle fontStyle: FontStyle = .regular
    ) -> UIFont? {
        return UIFont(name: "SFProText-\(fontStyle)", size: fontSize)
    }

}

enum FontStyle: String {
    case regular = "Regular"
    case bold = "Bold"
}
