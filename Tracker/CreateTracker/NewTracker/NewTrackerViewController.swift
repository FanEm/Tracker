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
    private let storage = Storage.shared
    private var name: String?
    private var trackerCategories: [TrackerCategory] {
        get {
            storage.trackerCategories
        }
        set {
            storage.trackerCategories = newValue
        }
    }

    var category: Category? = nil
    var schedule: Set<WeekDay> = []
    let type: NewTrackerViewControllerType
    
    init(type: NewTrackerViewControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        switch type {
        case .habit:
            view = NewHabitView()
        case .event:
            view = NewEventView()
        }
    }

    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        checkIfAllFieldsFilled()
    }
    
    private func checkIfAllFieldsFilled() {
        var isAllFieldsFilled = false
        switch type {
        case .habit:
            isAllFieldsFilled = name != nil && name != "" && category != nil && !schedule.isEmpty
        case .event:
            isAllFieldsFilled = name != nil && name != "" && category != nil
        }
        NotificationCenter.default.post(name: .didAllFieldsFilled, object: isAllFieldsFilled)
    }
}

// MARK: - NewTrackerBaseViewDelegate
extension NewTrackerViewController: NewTrackerBaseViewDelegate {
    func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    func didTapCreateButton() {
        guard let category else {
            assertionFailure("Some params are nil")
            return
        }
        let tracker = buildTracker()
        if trackerCategories.contains(where: {$0.name == category.name } ) {
            addTrackerToExistingCategory(tracker: tracker, category: category)
        } else {
            addTrackerToNewCategory(tracker: tracker, category: category)
        }
        NotificationCenter.default.post(name: .didNewTrackerCreated, object: nil)
        dismiss(animated: true)
    }
    
    private func buildTracker() -> Tracker {
        // TODO: добавить возможность выбрать цвет и эмоджи на экране
        let emojies = [
            "🙂", "😻", "🌺", "🐶", "❤️", "😱",
            "😇", "😡", "🥶", "🤔", "🙌", "🍔",
            "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
        ]

        let colors: [String] = [
            "#FD4C49", "#FF881E", "#007BFA", "#6E44FE", "#33CF69", "#E66DD4",
            "#F9D4D4", "#34A7FE", "#46E69D", "#35347C", "#FF674D", "#FF99CC",
            "#F6C48B", "#7994F5", "#832CF1", "#AD56DA", "#8D72E6", "#2FD058"
        ]
        return Tracker(
            id: UUID(),
            name: name ?? "",
            color: colors.randomElement()!,
            emoji: emojies.randomElement()!,
            schedule: type == .habit ? schedule : []
        )
    }
    
    private func addTrackerToExistingCategory(tracker: Tracker, category: Category) {
        var newCategories = trackerCategories
        let categoryToDelete = newCategories.first(where: { $0.name == category.name })!
        var trackers = categoryToDelete.trackers
        trackers.append(tracker)
        let newCategory = TrackerCategory(name: categoryToDelete.name, trackers: trackers)
        newCategories.removeAll(where: { $0.name == category.name })
        newCategories.append(newCategory)
        trackerCategories = newCategories
    }

    private func addTrackerToNewCategory(tracker: Tracker, category: Category) {
        let trackerCategory = TrackerCategory(
            name: category.name,
            trackers: [tracker]
        )
        trackerCategories.append(trackerCategory)
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