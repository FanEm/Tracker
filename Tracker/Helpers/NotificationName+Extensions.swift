//
//  NotificationName+Extensions.swift
//  Tracker
//

import Foundation

extension Notification.Name {
    static let didScheduleOrCategoryChosen = NSNotification.Name(rawValue: "DidScheduleOrCategoreChosen")
    static let didAllFieldsFilled = NSNotification.Name(rawValue: "DidAllFieldsFilled")
    static let didNewTrackerCreated = NSNotification.Name(rawValue: "DidNewTrackerCreated")
    static let didErrorLabelChangeState = NSNotification.Name(rawValue: "DidErrorLabelChangeState")
}
