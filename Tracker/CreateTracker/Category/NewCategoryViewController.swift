//
//  NewCategoryViewController.swift
//  Tracker
//

import UIKit

// MARK: - NewCategoryViewControllerDelegate
protocol NewCategoryViewControllerDelegate: AnyObject {
    func didTapOnDoneButton()
}

// MARK: - NewCategoryViewController
final class NewCategoryViewController: UIViewController {

    // MARK: - Public Properties
    weak var delegate: NewCategoryViewControllerDelegate?

    // MARK: - Private Properties
    private let newCategoryView = NewCategoryView()
    private let trackerService = TrackerService.shared

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        view = newCategoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newCategoryView.button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        hideKeyboardWhenTappedAround()
        newCategoryView.textField.delegate = self
    }

    // MARK: - Private Methods
    @objc private func onTap() {
        guard let text = newCategoryView.textField.text else { return }
        trackerService.add(categoryName: text)
        delegate?.didTapOnDoneButton()
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
