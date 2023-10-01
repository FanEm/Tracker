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
    var type: NewTrackerType? {
        presenter?.newTrackerModel.type
    }

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let presenter, let type else { return }
        presenter.analyticsService.didOpenNewTrackerScreen(type: type)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let presenter, let type else { return }
        presenter.analyticsService.didCloseNewTrackerScreen(type: type)
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
        guard let presenter, let type else { return }
        presenter.analyticsService.didClickCancel(type: type)
    }

    func didTapCreateButton() {
        presenter?.addOrEditTracker()
        NotificationCenter.default.post(name: .didNewTrackerCreated, object: nil)
        closePresentingController()
    }

}
