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
    private let newCategoryView = NewCategoryView()
    private let storage = Storage.shared

    weak var delegate: NewCategoryViewControllerDelegate?

    override func loadView() {
        view = newCategoryView
    }
    
    override func viewDidLoad() {
        newCategoryView.button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        hideKeyboardWhenTappedAround()
        newCategoryView.textField.delegate = self
    }

    @objc private func onTap() {
        guard let text = newCategoryView.textField.text else { return }
        storage.categories.append(Category(name: text))
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
