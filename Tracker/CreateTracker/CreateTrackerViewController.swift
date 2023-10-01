//
//  CreateTrackerViewController.swift
//  Tracker
//

import UIKit

// MARK: - CreateTrackerViewController
final class CreateTrackerViewController: UIViewController {

    // MARK: - Private Properties
    private let createTrackerView = CreateTrackerView()
    private let analyticsService = AnalyticsService()

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        view = createTrackerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createTrackerView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.didOpenCreateTrackerScreen()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.didCloseCreateTrackerScreen()
    }

    // MARK: - Private Methods
    private func presentNewTrackerViewController(type: NewTrackerType) {
        let presenter = NewTrackerPresenter(type: type)
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
