//
//  UIColor+Extensions.swift
//  Tracker
//

import UIKit

extension UIColor {

    static let trBlack = UIColor(named: "trBlack") ?? .black
    static let trPermBlack = UIColor(named: "trPermBlack") ?? .black
    static let trPermWhite = UIColor(named: "trPermWhite") ?? .white
    static let trWhite = UIColor(named: "trWhite") ?? .white
    static let trRed = UIColor(named: "trRed") ?? .red
    static let trBlue = UIColor(named: "trBlue") ?? .blue
    static let trGray = UIColor(named: "trGray") ?? .gray
    static let trLightGray = UIColor(named: "trLightGray") ?? .gray
    static let trDatePickerBtnBg = UIColor(named: "trDatePickerBtnBg") ?? .gray
    static let trBackground = UIColor(named: "trBackground") ?? .gray
    static let trTransperentWhite = UIColor(named: "trTransperentWhite") ?? .white
    static let trGradientBlue = UIColor(named: "trGradientBlue") ?? .blue
    static let trGradientRed = UIColor(named: "trGradientRed") ?? .red
    static let trGradientGreen = UIColor(named: "trGradientGreen") ?? .green
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }

 }
