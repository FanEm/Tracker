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
}

// MARK: - CreateTrackerViewDelegate
extension CreateTrackerViewController: CreateTrackerViewDelegate {
    func didTapHabitButton() {
        let viewController = NewTrackerViewController(type: .habit)
        present(viewController, animated: true)
    }
    
    func didTapEventButton() {
        let viewController = NewTrackerViewController(type: .event)
        present(viewController, animated: true)
    }
}
