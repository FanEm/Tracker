//
//  Set+Extensions.swift
//  Tracker
//


extension Set where Element == WeekDay {

    var toString: String {
        self.map { $0.rawValue }.joined(separator: ", ")
    }

}
