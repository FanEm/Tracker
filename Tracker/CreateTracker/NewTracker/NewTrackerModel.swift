//
//  NewTrackerModel.swift
//  Tracker
//

import Foundation

// MARK: - NewTrackerModel
struct NewTrackerModel {

    // MARK: - Public Properties
    var type: NewTrackerType
    var id: UUID = UUID()
    var name: String? {
        didSet {
            checkIfAllFieldsFilled()
        }
    }
    var emoji: String? {
        didSet {
            checkIfAllFieldsFilled()
        }
    }
    var color: String? {
        didSet {
            checkIfAllFieldsFilled()
        }
    }
    var category: Category? {
        didSet {
            checkIfAllFieldsFilled()
        }
    }
    var schedule: Set<WeekDay> = [] {
        didSet {
            checkIfAllFieldsFilled()
        }
    }

    // MARK: - Private Properties
    private var isNameValid: Bool {
        guard let name,
              name.count <= GlobalConstants.TextField.maxLength,
              !name.isEmpty else { return false }
        return true
    }

    // MARK: - Public Methods
    func buildTracker() -> Tracker {
        guard let name, let color, let emoji, let category else {
            fatalError("""
            Some of the params are nil.
            Params:
                name - \(String(describing: name)),
                color - \(String(describing: color)),
                emoji - \(String(describing: emoji)),
                category - \(String(describing: category))
            """)
        }
        let trackerSchedule: Set<WeekDay>
        switch type {
        case .habit: trackerSchedule = schedule
        case .event: trackerSchedule = Set(WeekDay.allCases)
        }
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: trackerSchedule,
            isPinned: false,
            type: type,
            category: category,
            previousCategoryId: nil
        )
    }

    func checkIfAllFieldsFilled() {
        var isAllFieldsFilled = false

        defer {
            NotificationCenter.default.post(name: .didAllFieldsFilled,
                                            object: isAllFieldsFilled)
        }

        guard isNameValid,
              category != nil,
              color != nil,
              emoji != nil else { return }

        switch type {
        case .habit: isAllFieldsFilled = !schedule.isEmpty
        case .event: isAllFieldsFilled = true
        }
    }

}
