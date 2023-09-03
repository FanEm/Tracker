//
//  NewTrackerModel.swift
//  Tracker
//

import Foundation


// MARK: - NewTrackerModel
struct NewTrackerModel {

    // MARK: - Public Properties
    var type: NewTrackerType
    var name: String? = nil {
        didSet {
            checkIfAllFieldsFilled()
        }
    }
    var emoji: String? = nil {
        didSet {
            checkIfAllFieldsFilled()
        }
    }
    var color: String? = nil {
        didSet {
            checkIfAllFieldsFilled()
        }
    }
    var category: Category? = nil {
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
        guard let name, let color, let emoji else {
            fatalError("""
            Some of the params are nil.
            Params:
                name - \(String(describing: name)),
                color - \(String(describing: color)),
                emoji - \(String(describing: emoji))
            """)
        }
        let trackerSchedule: Set<WeekDay>
        switch type {
            case .habit: trackerSchedule = schedule
            case .event: trackerSchedule = Set(WeekDay.allCases)
        }
        return Tracker(
            id: UUID(),
            name: name,
            color: color,
            emoji: emoji,
            schedule: trackerSchedule
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
