//
//  String+Extensions.swift
//  Tracker
//

import Foundation

extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    
    func localizedWithFormat(args: CVarArg..., withComment comment: String? = nil) -> String {
        return .localizedStringWithFormat(self.localized(), args)
    }
}
