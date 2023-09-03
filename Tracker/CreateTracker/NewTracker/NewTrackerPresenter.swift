//
//  NewTrackerPresenter.swift
//  Tracker
//

import Foundation


// MARK: - NewTrackerType
enum NewTrackerType {
    case habit
    case event
}


// MARK: - NewTrackerPresenterProtocol
protocol NewTrackerPresenterProtocol: AnyObject {
    var view: NewTrackerViewControllerProtocol? { get set }
    var newTrackerModel: NewTrackerModel { get }

    func addTracker()
}


// MARK: - NewTrackerPresenter
final class NewTrackerPresenter: NewTrackerPresenterProtocol {

    // MARK: - Public Properties
    weak var view: NewTrackerViewControllerProtocol?
    private(set) var newTrackerModel: NewTrackerModel

    // MARK: - Private Properties
    private let trackerService = TrackersService.shared

    // MARK: - Initializers
    init(type: NewTrackerType) {
        self.newTrackerModel = NewTrackerModel(type: type)
    }

    // MARK: - Public Methods
    func addTracker() {
        guard let category = newTrackerModel.category else {
            assertionFailure("Some params are nil")
            return
        }
        let tracker = newTrackerModel.buildTracker()
        trackerService.add(tracker: tracker, for: category.name)
    }

}


// MARK: - NewTrackerBaseViewDelegate
extension NewTrackerPresenter: NewTrackerBaseViewDelegate {

    func didTapOnColor(_ hexString: String) {
        newTrackerModel.color = hexString
    }

    func didTapOnEmoji(_ emoji: String) {
        newTrackerModel.emoji = emoji
    }

}


// MARK: - ScheduleViewControllerDelegate
extension NewTrackerPresenter: ScheduleViewControllerDelegate {

    func didTapDoneButton(schedule: Set<WeekDay>) {
        newTrackerModel.schedule = schedule
    }

}


// MARK: - CategoryViewControllerDelegate
extension NewTrackerPresenter: CategoryViewControllerDelegate {

    func didTapOnCategory(_ category: Category) {
        newTrackerModel.category = category
    }

}


// MARK: - NewEventHeaderViewDelegate
extension NewTrackerPresenter: NewTrackerHeaderViewDelegate {

    func didChangedTextField(text: String?) {
        newTrackerModel.name = text
    }

}
