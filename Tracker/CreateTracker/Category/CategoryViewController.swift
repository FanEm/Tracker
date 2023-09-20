//
//  CategoryViewController.swift
//  Tracker
//

import UIKit


// MARK: - CategoryViewControllerDelegate
protocol CategoryViewControllerDelegate: AnyObject {
    func didTapOnCategory(_ category: Category?)
}


// MARK: - CategoryViewController
final class CategoryViewController: UIViewController {

    // MARK: - Public Properties
    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - Private Properties
    private let emptyView = CategoryEmptyView()
    private let categoryView = CategoryView()
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
        setNeededView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryView.tableView.delegate = self
        categoryView.tableView.dataSource = self
        categoryView.button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        emptyView.button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        addBindToCategories()
    }

    // MARK: - Private Methods
    private func setNeededView() {
        view = categoryViewModel.categoriesExist ? categoryView : emptyView
    }

    private func addBindToCategories() {
        categoryViewModel.$categories.bind(action: { [weak self] _ in
            guard let self else { return }
            self.setNeededView()
            self.categoryView.tableView.reloadData()
        })
    }

    private func edit(indexPath: IndexPath) {
        guard let category = categoryViewModel.category(at: indexPath) else { return }

        let viewController = NewCategoryViewController(
            categoryViewModel: categoryViewModel,
            mode: .edit(name: category.name, indexPath: indexPath)
        )
        viewController.delegate = self
        present(viewController, animated: true)
    }

    private func delete(indexPath: IndexPath) {       
        AlertPresenter.show(in: self, model: .categoryDeleteConfirmation { [weak self] in
            guard let self,
                  let category = self.categoryViewModel.category(at: indexPath)
            else { return }
            if self.categoryViewModel.isCategorySelected(category) {
                self.selectCategory(nil)
            }
            self.categoryViewModel.deleteCategory(at: indexPath)
        })
    }

    private func selectCategory(_ category: Category?) {
        self.categoryViewModel.selectedCategory = category
        self.delegate?.didTapOnCategory(category)
        NotificationCenter.default.post(name: .didScheduleOrCategoryChosen, object: nil)
    }

    @objc private func onTap() {
        let viewController = NewCategoryViewController(
            categoryViewModel: categoryViewModel,
            mode: .new
        )
        present(viewController, animated: true)
    }

}


// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryViewModel.numberOfCategories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let сategoryCell = tableView.dequeueReusableCell(
                withIdentifier: CategoryCell.reuseId,
                for: indexPath) as? CategoryCell,
            let category = categoryViewModel.category(at: indexPath)
        else { return UITableViewCell() }

        let isCategorySelected = categoryViewModel.isCategorySelected(category)
        сategoryCell.configCell(label: category.name, isCategorySelected: isCategorySelected)
        tableView.hideLastSeparator(cell: сategoryCell, indexPath: indexPath)
        return сategoryCell
    }

}


// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = categoryViewModel.category(at: indexPath) else { return }
        categoryViewModel.configCell(in: tableView, at: indexPath)
        selectCategory(category)
        dismiss(animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard
            let category = categoryViewModel.category(at: indexPath),
            !categoryViewModel.isCategorySelected(category)
        else { return nil }
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            UIMenu(children: [
                UIAction(title: L.ContextMenu.edit) { [weak self] _ in
                    self?.edit(indexPath: indexPath)
                },
                UIAction(title: L.ContextMenu.delete, attributes: .destructive) { [weak self] _ in
                    self?.delete(indexPath: indexPath)
                },
            ])
        })
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UITableView.addCornerRadiusForFirstAndLastCells(tableView, cell: cell, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        GlobalConstants.TableViewCell.height
    }

}


// MARK: - NewCategoryViewControllerDelegate
extension CategoryViewController: NewCategoryViewControllerDelegate {

    func categoryWasRenamed(category: Category, newName: String) {
        if self.categoryViewModel.isCategorySelected(category) {
            self.selectCategory(Category(id: category.id, name: newName))
        }
    }

}
