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
}

// MARK: - EventType
enum EventType: String {
    case open
    case close
    case click
}

// MARK: - EventItem
enum EventItem: String {
    case addTracker = "add_tracker"
    case tracker
    case completeTracker = "complete_tracker"
    case incompleteTracker = "incomplete_tracker"
    case filters
    case pin
    case unpin
    case edit
    case delete
}

// MARK: - EventScreen
enum EventScreen: String {
    case main
    case newTracker = "new_tracker"
    case statistics
}
