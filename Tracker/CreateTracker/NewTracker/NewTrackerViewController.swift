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
    var schedule: Set<WeekDay> = []

    // MARK: - Private Properties
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
              !name.isEmpty else { return }
        
        switch type {
        case .habit: isAllFieldsFilled = !schedule.isEmpty
        case .event: isAllFieldsFilled = true
        }
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
        guard
            let categoryToDelete = newCategories.first(where: { $0.name == category.name })
        else {
            assertionFailure("There is no category with name '\(category.name)'")
            return
        }

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
