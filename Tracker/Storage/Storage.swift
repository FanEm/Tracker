//
//  Storage.swift
//  Tracker
//

import Foundation

// MARK: - Storage
final class Storage {

    // MARK: - Public Properties
    static let shared = Storage()

    var filter: FilterType {
        get {
            guard let data = userDefaults.data(forKey: Keys.filter.rawValue),
                  let record = try? JSONDecoder().decode(FilterType.self, from: data) else {
                return .today
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.filter.rawValue)
        }
    }

    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case filter
    }

    // MARK: - Initializers
    private init() { }
}
