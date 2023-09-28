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
        let presenter = TrackersPresenter(
            trackerService: TrackersService.shared,
            recordService: RecordService.shared
        )
        viewController.presenter = presenter
        presenter.view = viewController

        navigationController.viewControllers = [viewController]

        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: A.Icons.Tabbar.trackers.image,
            selectedImage: nil
        )
        navigationController.title = L.Trackers.title
        return navigationController
    }

    private var statisticsNavigationController: StatisticsNavigationController {
        let navigationController = StatisticsNavigationController()
        let viewModel = StatisticsViewModel(recordService: RecordService.shared)
        let viewController = StatisticsViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]

        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: A.Icons.Tabbar.statistics.image,
            selectedImage: nil
        )
        navigationController.title = L.Statistics.title
        return navigationController
    }

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        self.viewControllers = [trackersNavigationController, statisticsNavigationController]
    }

    // MARK: - Public Methods
    func showOnboardingIfNeeded() {
        let userDefaults = UserDefaults.standard
        if !userDefaults.wasOnboardingShown {
            let onboardingViewController = OnboardingPageViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: true)
            userDefaults.wasOnboardingShown = true
        }
    }

    // MARK: - Private Methods
    private func setupUI() {
        tabBar.backgroundColor = A.Colors.whiteDynamic.color
        tabBar.barTintColor = A.Colors.whiteDynamic.color
        tabBar.tintColor = A.Colors.blue.color
        tabBar.isTranslucent = false
        tabBar.barStyle = .default

        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 0.5
    }

}
