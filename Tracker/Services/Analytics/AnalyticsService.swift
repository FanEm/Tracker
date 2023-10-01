//
//  AnalyticsService.swift
//  Tracker
//

import YandexMobileMetrica
import os.log

// MARK: - AnalyticsService
struct AnalyticsService {

    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(
            apiKey: "d1706d76-5579-42ff-b83a-900151531e11"
        ) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }

    func report(params: EventParams) {
        let parameters = params.toDict
        let eventName = params.eventName
        YMMYandexMetrica.reportEvent(eventName, parameters: parameters, onFailure: { error in
            os_log("REPORT ERROR: %@", log: .default, type: .error, error.localizedDescription)
        })
        os_log("Event: %@, params: %@", log: .default, type: .info, eventName, parameters)
    }

}

// MARK: - Statistics screen
extension AnalyticsService {

    func didOpenStatisticsScreen() {
        report(params: EventParams(event: .open, screen: .statistics, item: nil))
    }

    func didCloseStatisticsScreen() {
        report(params: EventParams(event: .close, screen: .statistics, item: nil))
    }

}

// MARK: - Filters screen
extension AnalyticsService {

    func didOpenFiltersScreen() {
        report(params: EventParams(event: .open, screen: .filters, item: nil))
    }

    func didCloseFiltersScreen() {
        report(params: EventParams(event: .close, screen: .filters, item: nil))
    }

    func didChangeFilter() {
        report(params: EventParams(event: .click, screen: .filters, item: .changeFilter))
    }

}

// MARK: - CreateTracker screen
extension AnalyticsService {

    func didOpenCreateTrackerScreen() {
        report(params: EventParams(event: .open, screen: .createTracker, item: nil))
    }

    func didCloseCreateTrackerScreen() {
        report(params: EventParams(event: .close, screen: .createTracker, item: nil))
    }

}

// MARK: - NewTracker screen
extension AnalyticsService {

    func didOpenNewTrackerScreen(type: NewTrackerType) {
        switch type {
        case .event:
            report(params: EventParams(event: .open, screen: .newEvent, item: nil))
        case .habit:
            report(params: EventParams(event: .open, screen: .newHabit, item: nil))
        }
    }

    func didCloseNewTrackerScreen(type: NewTrackerType) {
        switch type {
        case .event:
            report(params: EventParams(event: .close, screen: .newEvent, item: nil))
        case .habit:
            report(params: EventParams(event: .close, screen: .newHabit, item: nil))
        }
    }

    func didClickCategory(type: NewTrackerType) {
        switch type {
        case .event:
            report(params: EventParams(event: .click, screen: .newEvent, item: .category))
        case .habit:
            report(params: EventParams(event: .click, screen: .newHabit, item: .category))
        }
    }

    func didClickSchedule(type: NewTrackerType) {
        switch type {
        case .event:
            report(params: EventParams(event: .click, screen: .newEvent, item: .schedule))
        case .habit:
            report(params: EventParams(event: .click, screen: .newHabit, item: .schedule))
        }
    }

    func didClickEmoji(type: NewTrackerType) {
        switch type {
        case .event:
            report(params: EventParams(event: .click, screen: .newEvent, item: .emoji))
        case .habit:
            report(params: EventParams(event: .click, screen: .newHabit, item: .emoji))
        }
    }

    func didClickColor(type: NewTrackerType) {
        switch type {
        case .event:
            report(params: EventParams(event: .click, screen: .newEvent, item: .color))
        case .habit:
            report(params: EventParams(event: .click, screen: .newHabit, item: .color))
        }
    }

    func didClickCancel(type: NewTrackerType) {
        switch type {
        case .event:
            report(params: EventParams(event: .click, screen: .newEvent, item: .cancel))
        case .habit:
            report(params: EventParams(event: .click, screen: .newHabit, item: .cancel))
        }
    }

    func didClickCreateTracker(type: NewTrackerType) {
        switch type {
        case .event:
            report(params: EventParams(event: .click, screen: .newEvent, item: .createTracker))
        case .habit:
            report(params: EventParams(event: .click, screen: .newHabit, item: .createTracker))
        }
    }

}

// MARK: - Category screen
extension AnalyticsService {

    func didOpenCategoryScreen() {
        report(params: EventParams(event: .open, screen: .category, item: nil))
    }

    func didCloseCategoryScreen() {
        report(params: EventParams(event: .close, screen: .category, item: nil))
    }

    func didClickAddCategory() {
        report(params: EventParams(event: .click, screen: .category, item: .addCategory))
    }

    func didClickEditCategory() {
        report(params: EventParams(event: .click, screen: .category, item: .editCategory))
    }

    func didClickDeleteCategory() {
        report(params: EventParams(event: .click, screen: .category, item: .deleteCategory))
    }

    func didSelectCategory() {
        report(params: EventParams(event: .click, screen: .category, item: .selectCategory))
    }

}

// MARK: - NewCategory screen
extension AnalyticsService {

    func didOpenNewCategoryScreen() {
        report(params: EventParams(event: .open, screen: .newCategory, item: nil))
    }

    func didCloseNewCategoryScreen() {
        report(params: EventParams(event: .close, screen: .newCategory, item: nil))
    }

    func didClickAddNewCategory() {
        report(params: EventParams(event: .click, screen: .newCategory, item: .addCategory))
    }

    func didClickEditNewCategory() {
        report(params: EventParams(event: .click, screen: .newCategory, item: .editCategory))
    }

}

// MARK: - Schedule screen
extension AnalyticsService {

    func didOpenScheduleScreen() {
        report(params: EventParams(event: .open, screen: .schedule, item: nil))
    }

    func didCloseScheduleScreen() {
        report(params: EventParams(event: .close, screen: .schedule, item: nil))
    }

    func didSelectSchedule() {
        report(params: EventParams(event: .click, screen: .schedule, item: .selectSchedule))
    }

}

// MARK: - Main screen
extension AnalyticsService {

    func didOpenMainScreen() {
        report(params: EventParams(event: .open, screen: .main, item: nil))
    }

    func didCloseMainScreen() {
        report(params: EventParams(event: .close, screen: .main, item: nil))
    }

    func didClickAddTracker() {
        report(params: EventParams(event: .click, screen: .main, item: .addTracker))
    }

    func didClickFilters() {
        report(params: EventParams(event: .click, screen: .main, item: .filters))
    }

    func didClickCompleteTracker() {
        report(params: EventParams(event: .click, screen: .main, item: .completeTracker))
    }

    func didClickIncompleteTracker() {
        report(params: EventParams(event: .click, screen: .main, item: .incompleteTracker))
    }

    func didClickEditTracker() {
        report(params: EventParams(event: .click, screen: .main, item: .editTracker))
    }

    func didClickDeleteTracker() {
        report(params: EventParams(event: .click, screen: .main, item: .deleteTracker))
    }

    func didClickPinTracker() {
        report(params: EventParams(event: .click, screen: .main, item: .pinTracker))
    }

    func didClickUnpinTracker() {
        report(params: EventParams(event: .click, screen: .main, item: .unpinTracker))
    }

    func didChangeDate() {
        report(params: EventParams(event: .click, screen: .main, item: .changeDate))
    }

}
