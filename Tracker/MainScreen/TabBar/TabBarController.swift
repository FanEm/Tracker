//
//  TabBarController.swift
//  Tracker
//

import UIKit

// MARK: - TabBarController
final class TabBarController: UITabBarController {

    
    // MARK: - Private Properties
    private var trackersNavigationController: TrackersNavigationController {
        let navigationController = TrackersNavigationController()
        let viewController = TrackersViewController()
        let presenter = TrackersPresenter(trackerService: TrackerService.shared)
        viewController.presenter = presenter
        presenter.view = viewController

        navigationController.viewControllers = [viewController]

        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: .Tabbar.trackers,
            selectedImage: nil
        )
        navigationController.title = "Trackers".localized()
        return navigationController
    }

    private var statisticsNavigationController: StatisticsNavigationController {
        let navigationController = StatisticsNavigationController()
        let viewController =  StatisticsViewController()
        navigationController.viewControllers = [viewController]

        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: .Tabbar.statistics,
            selectedImage: nil
        )
        navigationController.title = "Statistics".localized()
        return navigationController
    }

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setAppearance()

        self.viewControllers = [trackersNavigationController, statisticsNavigationController]
    }

    // MARK: - Private Methods
    private func setAppearance() {
        tabBar.backgroundColor = .trWhite
        tabBar.barTintColor = .trWhite
        tabBar.tintColor = .trBlue
        tabBar.isTranslucent = false
        tabBar.barStyle = .default

        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 0.5
    }
}

