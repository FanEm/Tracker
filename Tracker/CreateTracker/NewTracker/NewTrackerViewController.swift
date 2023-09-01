//
//  NewTrackerViewController.swift
//  Tracker
//

import UIKit


// MARK: - NewTrackerViewControllerProtocol
protocol NewTrackerViewControllerProtocol: AnyObject {
    var presenter: NewTrackerViewPresenterProtocol? { get set }
}


// MARK: - NewTrackerViewController
final class NewTrackerViewController: UIViewController, NewTrackerViewControllerProtocol {

    // MARK: - Public Properties
    var presenter: NewTrackerViewPresenterProtocol?

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        guard let presenter else { fatalError("Presenter is nil") }
        switch presenter.type {
        case .habit:
            view = NewHabitView()
        case .event:
            view = NewEventView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        presenter?.checkIfAllFieldsFilled()
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
        presenter?.addTracker()
        NotificationCenter.default.post(name: .didNewTrackerCreated, object: nil)
        closePresentingController()
    }

}
