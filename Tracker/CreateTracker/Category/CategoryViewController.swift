//
//  CategoryViewController.swift
//  Tracker
//

import UIKit

// MARK: - CategoryViewControllerDelegate
protocol CategoryViewControllerDelegate: AnyObject {
    func didTapOnCategory(_ category: Category)
}

// MARK: - CategoryViewController
final class CategoryViewController: UIViewController {
    private let storage = Storage.shared
    private let emptyView = CategoryEmptyView()
    private let categoryView = CategoryView()
    private var categories: [Category] {
        get {
            storage.categories
        }
        set {
            storage.categories = newValue
        }
    }
    var selectedCategory: Category?

    weak var delegate: CategoryViewControllerDelegate?

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
    }

    private func setNeededView() {
        view = categories.isEmpty ? emptyView : categoryView
    }

    @objc private func onTap() {
        let viewController = NewCategoryViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath)
        guard let сategoryCell = cell as? TitleTableViewCell else { return UITableViewCell() }

        сategoryCell.accessoryType = categories[indexPath.row] == selectedCategory ? .checkmark : .none
        сategoryCell.configCell(label: categories[indexPath.row].name)
        tableView.hideLastSeparator(cell: сategoryCell, indexPath: indexPath)
        return сategoryCell
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let category = categories[indexPath.row]
        tableView.visibleCells.forEach { $0.accessoryType = .none }
        selectedCategory = category
        cell.accessoryType = .checkmark
        delegate?.didTapOnCategory(category)
        NotificationCenter.default.post(name: .didScheduleOrCategoryChosen, object: nil)

        dismiss(animated: true)
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
    func didTapOnDoneButton() {
        setNeededView()
        categoryView.tableView.reloadData()
    }
}
