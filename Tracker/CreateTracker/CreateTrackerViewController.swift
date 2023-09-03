//
//  CreateTrackerViewController.swift
//  Tracker
//

import UIKit

// MARK: - CreateTrackerViewController
final class CreateTrackerViewController: UIViewController {

    // MARK: - Private Properties
    private let createTrackerView = CreateTrackerView()

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        view = createTrackerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createTrackerView.delegate = self
    }

    // MARK: - Private Methods
    private func presentNewTrackerViewController(type: NewTrackerViewControllerType) {
        let presenter = NewTrackerViewPresenter(type: type)
        let viewController = NewTrackerViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        present(viewController, animated: true)
    }

}

// MARK: - CreateTrackerViewDelegate
extension CreateTrackerViewController: CreateTrackerViewDelegate {
    func didTapHabitButton() {
        presentNewTrackerViewController(type: .habit)
    }
    
    func didTapEventButton() {
        presentNewTrackerViewController(type: .event)
    }
}
