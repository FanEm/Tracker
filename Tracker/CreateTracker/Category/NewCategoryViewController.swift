//
//  NewCategoryViewController.swift
//  Tracker
//

import UIKit

// MARK: - NewCategoryViewControllerDelegate
protocol NewCategoryViewControllerDelegate: AnyObject {
    func categoryWasRenamed(category: Category, newName: String)
}

// MARK: - NewCategoryViewController
final class NewCategoryViewController: UIViewController {

    // MARK: - Public Properties
    weak var delegate: NewCategoryViewControllerDelegate?

    // MARK: - Private Properties
    private let newCategoryView: NewCategoryView
    private let categoryViewModel: CategoryViewModel

    private var targetAction: Selector {
        switch newCategoryView.mode {
        case .new:
            return #selector(addNewCategory)
        case .edit:
            return #selector(renameCategory)
        }
    }

    // MARK: - Initializers
    init(categoryViewModel: CategoryViewModel, mode: NewCategoryMode) {
        self.categoryViewModel = categoryViewModel
        self.newCategoryView = NewCategoryView(mode: mode)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        view = newCategoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newCategoryView.button.addTarget(self, action: targetAction, for: .touchUpInside)
        newCategoryView.textField.delegate = self
        registerKeyboardObserver()
    }

    // MARK: - Private Methods
    @objc private func addNewCategory() {
        guard let categoryName = newCategoryView.textField.text else { return }
        let category = Category(id: UUID(), name: categoryName)
        if categoryViewModel.isCategoryExists(categoryName: categoryName) {
            showCategoryAlreadyExistsAlert()
            return
        }

        categoryViewModel.add(category: category)
        dismiss(animated: true)
    }

    @objc private func renameCategory() {
        guard let categoryName = newCategoryView.textField.text,
              let indexPath = newCategoryView.indexPath,
              let category = categoryViewModel.category(at: indexPath)
        else { return }

        if categoryViewModel.isCategoryExists(categoryName: categoryName) {
            showCategoryAlreadyExistsAlert()
            return
        }
        categoryViewModel.renameCategory(at: indexPath, to: categoryName)
        delegate?.categoryWasRenamed(category: category, newName: categoryName)

        dismiss(animated: true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        moveButtonWithKeyboard(willKeyboardShow: true, notification: notification)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        moveButtonWithKeyboard(willKeyboardShow: false, notification: notification)
    }

    private func moveButtonWithKeyboard(willKeyboardShow: Bool, notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        let keyboardSize = keyboardInfo.cgRectValue.size

        self.newCategoryView.buttonBottomAnchor.constant = willKeyboardShow
                                                           ? keyboardSize.height
                                                           : GlobalConstants.Button.bottomInset

        UIView.transition(with: newCategoryView, duration: animationDuration) { [weak self] in
            self?.newCategoryView.layoutIfNeeded()
        }
    }

    private func showCategoryAlreadyExistsAlert() {
        AlertPresenter.show(in: self, model: .categoryAlreadyExists)
    }

    private func registerKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

}

// MARK: - UITextFieldDelegate
extension NewCategoryViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

}
