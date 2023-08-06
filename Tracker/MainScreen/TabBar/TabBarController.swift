//
//  TabBarController.swift
//  Tracker
//

import UIKit

// MARK: - TabBarController
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setAppearance()

        self.viewControllers = [trackersNavigationController, statisticsNavigationController]
    }

    private var trackersNavigationController: TrackersNavigationController {
        let navigationController = TrackersNavigationController()
        let viewController = TrackersViewController()
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

    private func setAppearance() {
        tabBar.backgroundColor = .trWhite
        tabBar.barTintColor = .trWhite
        tabBar.tintColor = .trBlue
        tabBar.isTranslucent = false
        tabBar.barStyle = .default
        tabBar.clipsToBounds = true
    }
}

