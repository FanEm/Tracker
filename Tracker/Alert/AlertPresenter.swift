//
//  AlertPresenter.swift
//  Tracker
//

import UIKit

// MARK: - AlertPresenter
final class AlertPresenter {

    static func show(in controller: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: model.preferredStyle
        )

        if let primaryButton = model.primaryButton {
            let primaryButtonAction = UIAlertAction(
                title: primaryButton.text,
                style: primaryButton.style
            ) { _ in
                primaryButton.completion()
            }
            alert.addAction(primaryButtonAction)
        }

        if let secondaryButton = model.secondaryButton {
            let secondaryButtonAction = UIAlertAction(
                title: secondaryButton.text,
                style: secondaryButton.style
            ) { _ in
                secondaryButton.completion()
            }
            alert.addAction(secondaryButtonAction)
        }

        controller.present(alert, animated: true, completion: nil)
    }

}
