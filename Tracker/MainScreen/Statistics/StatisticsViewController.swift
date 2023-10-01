//
//  StatisticsViewController.swift
//  Tracker
//

import UIKit

// MARK: - StatisticsViewController
final class StatisticsViewController: UIViewController {

    // MARK: - Private Properties
    private let statisticsView = StatisticsView()
    private let emptyView = EmptyView(props: .statistics)
    private var viewModel: StatisticsViewModelProtocol

    // MARK: - Initializers
    init(viewModel: StatisticsViewModelProtocol) {
        self.viewModel = viewModel
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
        view.backgroundColor = A.Colors.whiteDynamic.color

        statisticsView.tableView.dataSource = self
        statisticsView.tableView.delegate = self

        configureNavigationBar()
        addBindToStatistics()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.analyticsService.didOpenStatisticsScreen()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.analyticsService.didCloseStatisticsScreen()
    }

    // MARK: Private Methods
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: A.Colors.blackDynamic.color
        ]
        navigationItem.title = L.Statistics.title
    }

    private func addBindToStatistics() {
        viewModel.onStatisticsChange = { [weak self] in
            guard let self else { return }
            self.setNeededView()
            self.statisticsView.tableView.reloadData()
        }
    }

    private func setNeededView() {
        view = viewModel.statistics.isEmpty ? emptyView : statisticsView
    }

}

// MARK: - StatisticsNavigationController
final class StatisticsNavigationController: UINavigationController {
}

// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        102
    }

}

// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.statistics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let statisticsCell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsTableViewCell.reuseIdentifier,
            for: indexPath) as? StatisticsTableViewCell
        else {
            return UITableViewCell()
        }
        let statistics = Array(viewModel.statistics)
            .sorted(by: { $0.type.rawValue < $1.type.rawValue })
        let statistic = statistics[indexPath.row]
        statisticsCell.configCell(
            title: statistic.type.title,
            count: statistic.count
        )
        return statisticsCell
    }

}
