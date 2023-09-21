//
//  NewTrackerViewController.swift
//  Tracker
//

import UIKit

// MARK: - NewTrackerViewControllerProtocol
protocol NewTrackerViewControllerProtocol: AnyObject {
    var presenter: NewTrackerPresenterProtocol? { get set }
}

// MARK: - NewTrackerViewController
final class NewTrackerViewController: UIViewController, NewTrackerViewControllerProtocol {

    // MARK: - Public Properties
    var presenter: NewTrackerPresenterProtocol?

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        guard let presenter else { fatalError("Presenter is nil") }
        switch presenter.newTrackerModel.type {
        case .habit:
            view = NewHabitView(mode: presenter.mode)
        case .event:
            view = NewEventView(mode: presenter.mode)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        presenter?.newTrackerModel.checkIfAllFieldsFilled()
        (view as? NewTrackerBaseView)?.delegate = presenter as? any NewTrackerBaseViewDelegate
    }

    // MARK: - Private Methods
    private func closePresentingController() {
        let presentingViewController = presentingViewController
        dismiss(animated: true) {
            presentingViewController?.dismiss(animated: true)
        }
    }

}

// MARK: - NewTrackerFooterViewDelegate
extension NewTrackerViewController: NewTrackerFooterViewDelegate {

    func didTapCancelButton() {
        dismiss(animated: true)
    }

    func didTapCreateButton() {
        presenter?.addOrEditTracker()
        NotificationCenter.default.post(name: .didNewTrackerCreated, object: nil)
        closePresentingController()
    }

}
