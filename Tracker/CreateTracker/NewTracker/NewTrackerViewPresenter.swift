//
//  NewTrackerViewPresenter.swift
//  Tracker
//

import Foundation


// MARK: - NewTrackerViewControllerType
enum NewTrackerViewControllerType {
    case habit
    case event
}


// MARK: - NewTrackerViewPresenterProtocol
protocol NewTrackerViewPresenterProtocol: AnyObject {
    var view: NewTrackerViewControllerProtocol? { get set }
    var type: NewTrackerViewControllerType { get }
    var category: Category? { get }
    var schedule: Set<WeekDay> { get }

    func addTracker()
    func checkIfAllFieldsFilled()
}


// MARK: - NewTrackerViewPresenter
final class NewTrackerViewPresenter: NewTrackerViewPresenterProtocol {

    // MARK: - Public Properties
    weak var view: NewTrackerViewControllerProtocol?

    private(set) var type: NewTrackerViewControllerType
    private(set) var category: Category? = nil
    private(set) var schedule: Set<WeekDay> = []

    // MARK: - Private Properties
    private let trackerService = TrackersService.shared

    private var name: String? = nil
    private var emoji: String? = nil
    private var color: String? = nil

    // MARK: - Initializers
    init(type: NewTrackerViewControllerType) {
        self.type = type
    }

    // MARK: - Public Methods
    func addTracker() {
        guard let category else {
            assertionFailure("Some params are nil")
            return
        }
        let tracker = buildTracker()
        trackerService.add(tracker: tracker, for: category.name)
    }

    func checkIfAllFieldsFilled() {
        var isAllFieldsFilled = false

        defer {
            NotificationCenter.default.post(name: .didAllFieldsFilled,
                                            object: isAllFieldsFilled)
        }

        guard let name,
              category != nil,
              !name.isEmpty,
              color != nil,
              emoji != nil else { return }

        switch type {
        case .habit: isAllFieldsFilled = !schedule.isEmpty
        case .event: isAllFieldsFilled = true
        }
    }

    // MARK: - Private Methods
    private func buildTracker() -> Tracker {
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

}


// MARK: - NewTrackerBaseViewDelegate
extension NewTrackerViewPresenter: NewTrackerBaseViewDelegate {

    func didTapOnColor(_ hexString: String) {
        self.color = hexString
        checkIfAllFieldsFilled()
    }
    
    func didTapOnEmoji(_ emoji: String) {
        self.emoji = emoji
        checkIfAllFieldsFilled()
    }

}


// MARK: - ScheduleViewControllerDelegate
extension NewTrackerViewPresenter: ScheduleViewControllerDelegate {

    func didTapDoneButton(schedule: Set<WeekDay>) {
        self.schedule = schedule
        checkIfAllFieldsFilled()
    }

}


// MARK: - CategoryViewControllerDelegate
extension NewTrackerViewPresenter: CategoryViewControllerDelegate {

    func didTapOnCategory(_ category: Category) {
        self.category = category
        checkIfAllFieldsFilled()
    }

}


// MARK: - NewEventHeaderViewDelegate
extension NewTrackerViewPresenter: NewTrackerHeaderViewDelegate {

    func didChangedTextField(text: String?) {
        self.name = text
        checkIfAllFieldsFilled()
    }

}
