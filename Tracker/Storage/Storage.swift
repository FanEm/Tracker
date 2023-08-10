//
//  Storage.swift
//  Tracker
//

import Foundation

// MARK: - Storage
final class Storage {

    // MARK: - Public Properties
    static let shared = Storage()

    var categories: [Category] {
        get {
            guard let data = userDefaults.data(forKey: Keys.categories.rawValue),
                  let record = try? JSONDecoder().decode([Category].self, from: data) else {
                return []
            }
            return record
        }
        set {          
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.categories.rawValue)
        }
    }
    
    var completedTrackers: [TrackerRecord] {
        get {
            guard let data = userDefaults.data(forKey: Keys.completedTrackers.rawValue),
                  let record = try? JSONDecoder().decode([TrackerRecord].self, from: data) else {
                return []
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.completedTrackers.rawValue)
        }
    }

    var trackerCategories: [TrackerCategory] {
        get {
            guard let data = userDefaults.data(forKey: Keys.trackers.rawValue),
                  let record = try? JSONDecoder().decode([TrackerCategory].self, from: data) else {
                return []
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.trackers.rawValue)
        }
    }
    
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
        case categories, filter, trackers, completedTrackers
    }

    // MARK: - Initializers
    private init() { }
}
