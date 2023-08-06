//
//  StatisticsViewController.swift
//  Tracker
//

import UIKit

// MARK: - StatisticsViewController
final class StatisticsViewController: UIViewController {   
    override func loadView() {
        view = EmptyView(props: .statistics)
    }

    override func viewDidLoad() {
        view.backgroundColor = .trWhite
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.trBlack]
        navigationItem.title = "Statistics".localized()
    }
}

// MARK: - StatisticsNavigationController
final class StatisticsNavigationController: UINavigationController {
}