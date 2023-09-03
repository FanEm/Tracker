//
//  TrackersViewController.swift
//  Tracker
//

import UIKit


// MARK: - TrackersViewControllerProtocol
protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersPresenterProtocol? { get set }
    
    func reloadCollectionView()
}


// MARK: - TrackersViewController
final class TrackersViewController: UIViewController, TrackersViewControllerProtocol {

    // MARK: - Public Properties
    var presenter: TrackersPresenterProtocol?

    // MARK: - Private Properties
    private static let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.timeZone = .current
        return formatter
    }()
    private enum State {
        case search
        case base
    }
    private let trackersView = TrackersView()
    private let emptyView = EmptyView(props: .trackers)
    private let nothingFoundView = EmptyView(props: .search)

    private var currentDate: Date = Date().stripTime()
    private var state: State = .base

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
        presenter?.viewDidLoad()
        setNeededView()
        trackersView.collectionView.delegate = self
        trackersView.collectionView.dataSource = self
        createNewTrackerCreatedObserver()
    }
    
    // MARK: - Public Methods
    func setNeededView() {
        var suitableEmptyView: UIView
        switch state {
        case .base:
            suitableEmptyView = emptyView
            trackersView.showFilterButton(true)
        case .search:
            suitableEmptyView = nothingFoundView
            trackersView.showFilterButton(false)
        }
        view = presenter?.numberOfSections == 0 ? suitableEmptyView : trackersView
    }

    @objc func reloadCollectionView() {
        presenter?.fetchTrackers(date: currentDate)
        setNeededView()
        trackersView.collectionView.reloadData()
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
        reloadCollectionView()
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
            state = .base
            presenter?.fetchTrackers(date: currentDate)
        } else {
            state = .search
            presenter?.fetchTrackers(searchText: searchText)
        }
        setNeededView()
        trackersView.collectionView.reloadData()
    }
}


// MARK: - UISearchControllerDelegate
extension TrackersViewController: UISearchControllerDelegate {
}


// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfItemsInSection(section) ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.numberOfSections ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let trackerCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
                for: indexPath) as? TrackerCollectionViewCell,
            let presenter,
            let tracker = presenter.tracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }
        trackerCollectionViewCell.delegate = self
        trackerCollectionViewCell.currentDate = currentDate
        trackerCollectionViewCell.tracker = tracker
        trackerCollectionViewCell.isTrackerCompleted = presenter.isTrackerCompleted(tracker)
        trackerCollectionViewCell.doneCounter = presenter.completeCounterForTracker(tracker)
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
            sectionTitleView.titleLabel.text = presenter?.categoryTitle(at: indexPath)
            return sectionTitleView
        }
        return UICollectionReusableView()
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    private enum CollectionViewConstants {
        static let itemHeight: CGFloat = 148
        static let headerHeight: CGFloat = 19
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

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return CollectionViewConstants.sectionInset
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: CollectionViewConstants.headerHeight
        )
    }
}


// MARK: - TrackerCollectionViewCellDelegate
extension TrackersViewController: TrackerCollectionViewCellDelegate {

    func didTapOnQuantityButton(_ cell: TrackerCollectionViewCell) {
        guard let tracker = cell.tracker, let presenter else { return }
        if cell.isTrackerCompleted {
            presenter.markTrackerAsNotCompleted(tracker)
        } else {
            presenter.markTrackerAsCompleted(tracker)
        }
        cell.isTrackerCompleted = !cell.isTrackerCompleted
        cell.doneCounter = presenter.completeCounterForTracker(tracker)
    }

}
