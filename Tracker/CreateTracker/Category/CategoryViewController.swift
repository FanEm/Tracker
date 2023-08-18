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

    // MARK: - Public Properties
    var selectedCategory: Category?
    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - Private Properties
    private let trackerService = TrackerService.shared
    private let emptyView = CategoryEmptyView()
    private let categoryView = CategoryView()
    private var categories: [Category] {
        get {
            trackerService.categories
        }
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
    }

    // MARK: - Private Methods
    private func setNeededView() {
        view = categories.isEmpty ? emptyView : categoryView
    }

    @objc private func onTap() {
        let viewController = NewCategoryViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }

    private func configCell(in tableView: UITableView, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        tableView.visibleCells.forEach { $0.accessoryType = .none }
        cell.accessoryType = .checkmark
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerService.numberOfCategories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath)
        guard let сategoryCell = cell as? TitleTableViewCell else { return UITableViewCell() }
        let category = categories[indexPath.row]
        сategoryCell.accessoryType = category == selectedCategory ? .checkmark : .none
        сategoryCell.configCell(label: category.name)
        tableView.hideLastSeparator(cell: сategoryCell, indexPath: indexPath)
        return сategoryCell
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        configCell(in: tableView, at: indexPath)
        let category = categories[indexPath.row]
        selectedCategory = category
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
        assert(Thread.isMainThread)
        setNeededView()
        categoryView.tableView.reloadData()
    }
}
