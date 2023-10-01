//
//  EventParams.swift
//  Tracker
//

// MARK: - EventParams
struct EventParams {
    let event: EventType
    let screen: EventScreen
    let item: EventItem?

    var toDict: [String: String] {
        [
            "event": event.rawValue,
            "screen": screen.rawValue,
            "item": item?.rawValue
        ].compactMapValues { $0 }
    }

    var eventName: String {
        [screen.rawValue, event.rawValue, item?.rawValue].compactMap { $0 }.joined(separator: "_")
    }

}

// MARK: - EventType
enum EventType: String {
    case open
    case close
    case click
}

// MARK: - EventItem
enum EventItem: String {

    // MARK: - Main
    case addTracker = "add_tracker"
    case changeDate = "change_date"
    case filters
    case completeTracker = "complete_tracker"
    case incompleteTracker = "incomplete_tracker"
    case pinTracker = "pin_tracker"
    case unpinTracker = "unpin_tracker"
    case editTracker = "edit_tracker"
    case deleteTracker = "delete_tracker"

    // MARK: - Filter
    case changeFilter = "change_filter"

    // MARK: - Category
    case selectSchedule = "select_schedule"

    // MARK: - Category
    case selectCategory = "select_category"
    case addCategory = "add_category"
    case editCategory = "edit_category"
    case deleteCategory = "delete_category"

    // MARK: - NewTracker
    case category
    case schedule
    case emoji
    case color
    case cancel
    case createTracker = "create_tracker"

}

// MARK: - EventScreen
enum EventScreen: String {
    case main
    case newEvent = "new_event"
    case newHabit = "new_habit"
    case statistics
    case filters
    case category
    case newCategory = "new_category"
    case schedule
    case createTracker = "create_tracker"
}
