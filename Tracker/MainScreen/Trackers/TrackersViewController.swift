//
//  TrackersViewController.swift
//  Tracker
//

import UIKit

// MARK: - TrackersViewController
final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private static let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.timeZone = .current
        return formatter
    }()

    private let storage = Storage.shared
    private let trackersView = TrackersView()
    private let emptyView = EmptyView(props: .trackers)
    private let nothingFoundView = EmptyView(props: .search)

    private var currentDate: Date = Date().stripTime()
    private var visibleCategories: [TrackerCategory] = []

    private var trackerCategories: [TrackerCategory] {
        get {
            return storage.trackerCategories
        }
        set {
            storage.trackerCategories = newValue
        }
    }
    private var completedTrackers: [TrackerRecord] {
        get {
            return storage.completedTrackers
        }
        set {
            storage.completedTrackers = newValue
        }
    }

    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }

    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.searchBar.tintColor = .trBlue
        sc.searchBar.placeholder = "Search".localized()
        return sc
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .trBlue
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        return datePicker
    }()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        filterCategoriesByDate()
        setNeededView()

        trackersView.collectionView.delegate = self
        trackersView.collectionView.dataSource = self

        createNewTrackerCreatedObserver()
    }

    // MARK: - Private Methods
    private func configureNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }

        let leftButton = UIBarButtonItem(
            image: .Trackers.addTracker,
            style: .plain,
            target: self,
            action: #selector(presentCreateTrackerViewController)
        )
        navBar.topItem?.setLeftBarButton(leftButton, animated: false)

        let barButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.setRightBarButton(barButton, animated: false)

        navBar.prefersLargeTitles = true
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.trBlack]
        navigationItem.title = "Trackers".localized()

        navigationItem.searchController = searchController

        navBar.tintColor = .trBlack
    }

    private func dateCondition(tracker: Tracker) -> Bool {
        let dayOfWeek = currentDate.dayOfTheWeek()
        return tracker.schedule.contains(dayOfWeek)
    }

    private func searchCondition(tracker: Tracker, searchText: String) -> Bool {
        tracker.name.lowercased().contains(searchText.lowercased())
    }

    private func searchAndDateCondition(tracker: Tracker, searchText: String) -> Bool {
        searchCondition(tracker: tracker, searchText: searchText) && dateCondition(tracker: tracker)
    }

    private func filterCategoriesByDate() {
        visibleCategories = trackerCategories.map { category in
            let trackers = category.trackers.filter { dateCondition(tracker: $0) }
            return TrackerCategory(name: category.name, trackers: trackers)
        }.filter { $0.trackers.count > 0 }
    }
    
    private func filterCategoriesBySearchText(_ searchText: String) {
        visibleCategories = trackerCategories.map { category in
            let trackers = category.trackers.filter { searchAndDateCondition(tracker: $0, searchText: searchText) }
            return TrackerCategory(name: category.name, trackers: trackers)
        }.filter { $0.trackers.count > 0 }
    }

    private func setNeededView(isSearch: Bool = false) {
        let suitableEmptyView = isSearch ? nothingFoundView : emptyView
        view = visibleCategories.isEmpty ? suitableEmptyView : trackersView
    }

    private func createNewTrackerCreatedObserver() {
        return NotificationCenter.default.addObserver(self,
                                                      selector: #selector(reloadCollectionView),
                                                      name: .didNewTrackerCreated,
                                                      object: nil)
    }

    @objc private func presentCreateTrackerViewController() {
        let viewController = CreateTrackerViewController()
        present(viewController, animated: true)
    }

    @objc private func datePickerChanged(picker: UIDatePicker) {
        currentDate = picker.date.stripTime()
        filterCategoriesByDate()
        setNeededView()
        trackersView.collectionView.reloadData()
    }

    @objc private func reloadCollectionView() {
        filterCategoriesByDate()
        setNeededView()
        trackersView.collectionView.reloadData()
    }
}

// MARK: - TrackersNavigationController
final class TrackersNavigationController: UINavigationController {
}

// MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text)
    }
    
    private func filterContentForSearchText(_ searchText: String?) {
        if searchBarIsEmpty {
            filterCategoriesByDate()
            trackersView.hideFilterButton(false)
            setNeededView()
        } else {
            trackersView.hideFilterButton(true)
            if let searchText { filterCategoriesBySearchText(searchText) }
            setNeededView(isSearch: true)
        }
        trackersView.collectionView.reloadData()
    }
}

// MARK: - UISearchControllerDelegate
extension TrackersViewController: UISearchControllerDelegate {
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath) as? TrackerCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        trackerCollectionViewCell.currentDate = currentDate
        trackerCollectionViewCell.tracker = tracker
        trackerCollectionViewCell.configCell(tracker: tracker)
        return trackerCollectionViewCell
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let sectionTitleView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: BaseSectionTitleView.reuseIdentifier,
            for: indexPath) as? BaseSectionTitleView
        {
            sectionTitleView.titleLabel.text = visibleCategories[indexPath.section].name
            return sectionTitleView
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    private enum CollectionViewConstants {
        static let itemHeight: CGFloat = 148
        static let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let minimumInteritemSpacing: CGFloat = 9
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width / 2 - 25,
            height: CollectionViewConstants.itemHeight
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return CollectionViewConstants.minimumInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return CollectionViewConstants.sectionInset
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return getReferenceSize(
            collectionView: collectionView,
            section: section,
            kind: UICollectionView.elementKindSectionHeader
        )
    }

    func getReferenceSize(collectionView: UICollectionView, section: Int, kind: String) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let view = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: kind,
            at: indexPath
        )
        return view.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
