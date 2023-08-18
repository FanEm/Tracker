//
//  NewTrackerViewController.swift
//  Tracker
//

import UIKit

// MARK: - NewTrackerViewControllerType
enum NewTrackerViewControllerType {
    case habit
    case event
}

// MARK: - NewTrackerViewController
final class NewTrackerViewController: UIViewController {

    // MARK: - Public Properties
    let type: NewTrackerViewControllerType
    var category: Category? = nil
    var emoji: String? = nil
    var color: String? = nil
    var schedule: Set<WeekDay> = []

    // MARK: - Private Properties
    private let trackerService = TrackerService.shared
    private var name: String?

    // MARK: - Initializers
    init(type: NewTrackerViewControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        switch type {
        case .habit:
            view = NewHabitView()
        case .event:
            view = NewEventView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        checkIfAllFieldsFilled()
        (view as? NewTrackerBaseView)?.delegate = self
    }

    // MARK: - Private Methods
    private func checkIfAllFieldsFilled() {
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

    private func closePresentingController() {
        let presentingViewController = presentingViewController
        dismiss(animated: true) {
            presentingViewController?.dismiss(animated: true)
        }
    }
}


// MARK: - NewTrackerBaseViewDelegate
extension NewTrackerViewController: NewTrackerBaseViewDelegate {
    func didTapOnColor(_ hexString: String) {
        self.color = hexString
        checkIfAllFieldsFilled()
    }
    
    func didTapOnEmoji(_ emoji: String) {
        self.emoji = emoji
        checkIfAllFieldsFilled()
    }
}


// MARK: - NewTrackerFooterViewDelegate
extension NewTrackerViewController: NewTrackerFooterViewDelegate {
    func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    func didTapCreateButton() {
        guard let category else {
            assertionFailure("Some params are nil")
            return
        }
        let tracker = buildTracker()
        trackerService.add(tracker: tracker, for: category.name)
        NotificationCenter.default.post(name: .didNewTrackerCreated, object: nil)
        closePresentingController()
    }
}

// MARK: - ScheduleViewControllerDelegate
extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func didTapDoneButton(schedule: Set<WeekDay>) {
        self.schedule = schedule
        checkIfAllFieldsFilled()
    }
}

// MARK: - CategoryViewControllerDelegate
extension NewTrackerViewController: CategoryViewControllerDelegate {
    func didTapOnCategory(_ category: Category) {
        self.category = category
        checkIfAllFieldsFilled()
    }
}

// MARK: - NewEventHeaderViewDelegate
extension NewTrackerViewController: NewTrackerHeaderViewDelegate {
    func didChangedTextField(text: String?) {
        self.name = text
        checkIfAllFieldsFilled()
    }
}
