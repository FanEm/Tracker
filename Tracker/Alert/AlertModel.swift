//
//  AlertModel.swift
//  Tracker
//

import UIKit

// MARK: - AlertModel
struct AlertModel {

    let title: String
    let message: String?
    let primaryButton: AlertButton?
    let secondaryButton: AlertButton?
    let preferredStyle: UIAlertController.Style

    static var categoryAlreadyExists: AlertModel {
        AlertModel(
            title: L.NewCategory.Alert.title,
            message: L.NewCategory.Alert.subtitle,
            primaryButton: AlertButton(text: L.Alert.ok, style: .cancel, completion: {}),
            secondaryButton: nil,
            preferredStyle: .alert
        )
    }

    static func categoryDeleteConfirmation(primaryButtonCompletion: @escaping () -> Void) -> AlertModel {
        AlertModel(
            title: L.Category.Alert.Delete.title,
            message: L.Category.Alert.Delete.subtitle,
            primaryButton: AlertButton(
                text: L.Alert.delete,
                style: .destructive,
                completion: primaryButtonCompletion
            ),
            secondaryButton: AlertButton(text: L.Alert.cancel, style: .cancel, completion: {}),
            preferredStyle: .actionSheet
        )
    }

    static func trackerDeleteConfirmation(primaryButtonCompletion: @escaping () -> Void) -> AlertModel {
        AlertModel(
            title: L.Trackers.Alert.Delete.title,
            message: nil,
            primaryButton: AlertButton(
                text: L.Alert.delete,
                style: .destructive,
                completion: primaryButtonCompletion
            ),
            secondaryButton: AlertButton(text: L.Alert.cancel, style: .cancel, completion: {}),
            preferredStyle: .actionSheet
        )
    }

}
