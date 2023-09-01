//
//  NewCategoryViewController.swift
//  Tracker
//

import UIKit


// MARK: - NewCategoryViewController
final class NewCategoryViewController: UIViewController {

    // MARK: - Private Properties
    private let newCategoryView = NewCategoryView()
    private let categoryViewModel: CategoryViewModel

    // MARK: - Initializers
    init(categoryViewModel: CategoryViewModel) {
        self.categoryViewModel = categoryViewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        categoryViewModel.add(categoryName: text)
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
