//
//  StatisticsViewController.swift
//  Tracker
//

import UIKit

// MARK: - StatisticsViewController
final class StatisticsViewController: UIViewController {

    // MARK: - Overrides Methods
    override func loadView() {
        super.loadView()
        view = EmptyView(props: .statistics)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trWhite
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.trBlack]
        navigationItem.title = "Statistics".localized()
    }
}

// MARK: - StatisticsNavigationController
final class StatisticsNavigationController: UINavigationController {
}
