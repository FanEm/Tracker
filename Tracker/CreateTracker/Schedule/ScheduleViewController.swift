//
//  ScheduleViewController.swift
//  Tracker
//

import UIKit

// MARK: - ScheduleViewControllerDelegate
protocol ScheduleViewControllerDelegate: AnyObject {
    func didTapDoneButton(schedule: Set<WeekDay>)
}

// MARK: - ScheduleViewController
final class ScheduleViewController: UIViewController {

    // MARK: - Public Properties
    var schedule: Set<WeekDay> = []
    weak var delegate: ScheduleViewControllerDelegate?

    // MARK: - Private Properties
    private let analyticsService = AnalyticsService()
    private let scheduleView = ScheduleView()
    private let weekDays: [WeekDay] = WeekDay.allCases

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        view = scheduleView
        scheduleView.button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleView.tableView.dataSource = self
        scheduleView.tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.didOpenScheduleScreen()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.didCloseScheduleScreen()
    }

    // MARK: - Private Methods
    @objc private func onTap() {
        delegate?.didTapDoneButton(schedule: schedule)
        NotificationCenter.default.post(name: .didScheduleOrCategoryChosen, object: nil)
        analyticsService.didSelectSchedule()
        dismiss(animated: true)
    }

}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseId, for: indexPath)
        guard let scheduleCell = cell as? ScheduleCell else { return UITableViewCell() }

        let weekDay = weekDays[indexPath.row]
        scheduleCell.delegate = self
        scheduleCell.configCell(label: weekDay.name, isOn: schedule.contains(weekDay), indexPath: indexPath)
        tableView.hideLastSeparator(cell: scheduleCell, indexPath: indexPath)
        return scheduleCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        GlobalConstants.TableViewCell.height
    }

}

// MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        UITableView.addCornerRadiusForFirstAndLastCells(tableView, cell: cell, indexPath: indexPath)
    }

}

// MARK: - ScheduleCellDelegate
extension ScheduleViewController: ScheduleCellDelegate {

    func didSwitchChanged(to isOn: Bool, forCellAt index: Int) {
        if isOn {
            schedule.insert(weekDays[index])
        } else {
            schedule.remove(weekDays[index])
        }
    }

}
