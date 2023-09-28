//
//  NewTrackerPresenter.swift
//  Tracker
//

// MARK: - NewTrackerPresenterProtocol
protocol NewTrackerPresenterProtocol: AnyObject {
    var view: NewTrackerViewControllerProtocol? { get set }
    var newTrackerModel: NewTrackerModel { get }
    var mode: NewTrackerMode { get }

    func addOrEditTracker()
}

// MARK: - NewTrackerPresenter
final class NewTrackerPresenter: NewTrackerPresenterProtocol {

    // MARK: - Public Properties
    weak var view: NewTrackerViewControllerProtocol?
    private(set) var newTrackerModel: NewTrackerModel
    private(set) var mode: NewTrackerMode

    // MARK: - Private Properties
    private let trackerService = TrackersService.shared
    private let categoryService = CategoryService.shared

    // MARK: - Initializers
    init(type: NewTrackerType, mode: NewTrackerMode = .new) {
        self.mode = mode
        self.newTrackerModel = NewTrackerModel(type: type)
    }

    // MARK: - Public Methods
    func addOrEditTracker() {
        let tracker = newTrackerModel.buildTracker()
        switch mode {
        case .new:
            trackerService.add(tracker: tracker)
        case .edit(let indexPath):
            trackerService.editTracker(at: indexPath, newTracker: tracker)
        }
    }

    func configureNewTrackerModel(tracker: Tracker) {
        newTrackerModel.id = tracker.id
        newTrackerModel.name = tracker.name
        newTrackerModel.emoji = tracker.emoji
        newTrackerModel.color = tracker.color
        newTrackerModel.schedule = tracker.schedule
        newTrackerModel.category = tracker.category.type == .pin
                                   ? categoryForPinnedTracker(tracker)
                                   : tracker.category
    }

    // MARK: - Private Methods
    private func categoryForPinnedTracker(_ tracker: Tracker) -> Category {
        guard
            let previousCategoryId = tracker.previousCategoryId,
            let category = categoryService.category(with: previousCategoryId)
        else {
            fatalError("There should be previousCategoryId for pinned tracker")
        }
        return category
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

    func didTapOnCategory(_ category: Category?) {
        newTrackerModel.category = category
    }

}

// MARK: - NewEventHeaderViewDelegate
extension NewTrackerPresenter: NewTrackerHeaderViewDelegate {

    func didChangedTextField(text: String?) {
        newTrackerModel.name = text
    }

}
