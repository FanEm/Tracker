//
//  FiltersViewController.swift
//  Tracker
//

import UIKit

// MARK: - FiltersViewController
final class FiltersViewController: UIViewController {
    private let filtersView = FiltersView()
    private let storage = Storage.shared
    private let filters: [FilterType] = [.all, .today, .completed, .inProgress]
    private var currentFilter: FilterType {
        get {
            storage.filter
        }
        set {
            storage.filter = newValue
        }
    }

    override func loadView() {
        super.loadView()
        view = filtersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersView.tableView.delegate = self
        filtersView.tableView.dataSource = self
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
        checkCell(at: indexPath, in: tableView)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UITableView.addCornerRadiusForFirstAndLastCells(tableView, cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        GlobalConstants.TableViewCell.height
    }

    private func checkCell(at indexPath: IndexPath, in tableView: UITableView) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        tableView.visibleCells.forEach { visibleCell in
            visibleCell.accessoryType = .none
            visibleCell.isSelected = false
        }
        let filter = filters[indexPath.row]
        if cell.accessoryType != .checkmark {
            cell.accessoryType = .checkmark
            cell.isSelected = true
            currentFilter = filter
        }
    }
}

// MARK: - FilterType
enum FilterType: String, Codable {
    case all
    case today
    case completed
    case inProgress
    
    var name: String {
        var name: String
        switch self {
        case .all:
            name = "All trackers"
        case .today:
            name = "Trackers for today"
        case .completed:
            name = "Сompleted"
        case .inProgress:
            name = "Not completed"
        }
        return name.localized()
    }
}
