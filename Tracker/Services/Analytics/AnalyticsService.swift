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

    func report(event: EventName, params: EventParams) {
        let parameters = params.toDict
        let eventName = event.rawValue
        YMMYandexMetrica.reportEvent(eventName, parameters: parameters, onFailure: { error in
            os_log("REPORT ERROR: %@", log: .default, type: .error, error.localizedDescription)
        })
        os_log("Event: %@, params: %@", log: .default, type: .info, eventName, parameters)
    }

}

// MARK: - Events
extension AnalyticsService {

    func didOpenMainScreen() {
        report(event: .openMain, params: EventParams(event: .open, screen: .main, item: nil))
    }

    func didCloseMainScreen() {
        report(event: .openMain, params: EventParams(event: .close, screen: .main, item: nil))
    }

    func didClickAddTracker() {
        report(event: .clickAddTracker, params: EventParams(event: .click, screen: .main, item: .addTracker))
    }

    func didClickFilters() {
        report(event: .clickFilters, params: EventParams(event: .click, screen: .main, item: .filters))
    }

    func didClickCompleteTracker() {
        report(event: .clickCompleteTracker, params: EventParams(event: .click, screen: .main, item: .completeTracker))
    }
    
    func didClickIncompleteTracker() {
        report(event: .clickIncompleteTracker, params: EventParams(event: .click, screen: .main, item: .incompleteTracker))
    }
    
    func didClickEditTracker() {
        report(event: .clickEditTracker, params: EventParams(event: .click, screen: .main, item: .edit))
    }
    
    func didClickDeleteTracker() {
        report(event: .clickDeleteTracker, params: EventParams(event: .click, screen: .main, item: .delete))
    }
    
    func didClickPinTracker() {
        report(event: .clickPinTracker, params: EventParams(event: .click, screen: .main, item: .pin))
    }
    
    func didClickUnpinTracker() {
        report(event: .clickPinTracker, params: EventParams(event: .click, screen: .main, item: .unpin))
    }

}
