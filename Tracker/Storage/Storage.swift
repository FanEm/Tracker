//
//  Storage.swift
//  Tracker
//

import Foundation

// MARK: - UserDefaults
extension UserDefaults {

    private enum Keys: String {
        case filter, wasOnboardingShown
    }

    var wasOnboardingShown: Bool {
        get {
            bool(forKey: Keys.wasOnboardingShown.rawValue)
        }
        set {
            set(newValue, forKey: Keys.wasOnboardingShown.rawValue)
        }
    }

    @objc dynamic var filter: FilterType {
        get {
            guard let data = data(forKey: Keys.filter.rawValue),
                  let record = try? JSONDecoder().decode(FilterType.self, from: data) else {
                return .all
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            set(data, forKey: Keys.filter.rawValue)
        }
    }

}
