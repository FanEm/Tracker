//
//  FiltersViewController.swift
//  Tracker
//

import UIKit

// MARK: - FiltersViewController
final class FiltersViewController: UIViewController {

    // MARK: - Private Properties
    private let filtersView = FiltersView()
    private let userDefaults = UserDefaults.standard
    private let analyticsService = AnalyticsService()
    private let filters: [FilterType] = [.all, .today, .completed, .incompleted]
    private var currentFilter: FilterType {
        get {
            userDefaults.filter
        }
        set {
            userDefaults.filter = newValue
        }
    }

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        view = filtersView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        filtersView.tableView.delegate = self
        filtersView.tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.didOpenFiltersScreen()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.didCloseFiltersScreen()
    }

    // MARK: - Private Methods
    private func selectCell(in tableView: UITableView, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        tableView.visibleCells.forEach { $0.accessoryType = .none }
        cell.accessoryType = .checkmark
        currentFilter = filters[indexPath.row]
        analyticsService.didChangeFilter()
    }

}

// MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let filtersCell = tableView.dequeueReusableCell(
            withIdentifier: TitleTableViewCell.reuseIdentifier,
            for: indexPath) as? TitleTableViewCell
        else {
            return UITableViewCell()
        }

        filtersCell.accessoryType = filters[indexPath.row] == currentFilter ? .checkmark : .none
        filtersCell.configCell(label: filters[indexPath.row].name)
        tableView.hideLastSeparator(cell: filtersCell, indexPath: indexPath)
        return filtersCell
    }

}

// MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell(in: tableView, at: indexPath)
        dismiss(animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        UITableView.addCornerRadiusForFirstAndLastCells(tableView, cell: cell, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        GlobalConstants.TableViewCell.height
    }

}
