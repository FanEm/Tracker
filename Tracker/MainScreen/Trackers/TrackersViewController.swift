//
//  TrackersViewController.swift
//  Tracker
//

import UIKit

// MARK: - TrackersViewControllerProtocol
protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersPresenterProtocol? { get set }

    func reloadCollectionView(searchText: String?)
}

// MARK: - TrackersViewController
final class TrackersViewController: UIViewController, TrackersViewControllerProtocol {

    // MARK: - Public Properties
    var presenter: TrackersPresenterProtocol?

    // MARK: - Private Properties
    private enum State {
        case search
        case base
    }
    private enum Constants {
        enum FilterButton {
            static let bottomInset: CGFloat = 16
        }
    }
    private let userDefaults = UserDefaults.standard
    private let trackersView = TrackersView()
    private let emptyView = EmptyView(props: .trackers)
    private let nothingFoundView = EmptyView(props: .search)

    private var currentDate: Date = Date().stripTime()
    private var currentFilter: FilterType {
        get {
            userDefaults.filter
        }
        set {
            userDefaults.filter = newValue
        }
    }
    private var state: State = .base
    private var filterObservation: NSKeyValueObservation?

    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.searchBar.tintColor = A.Colors.blue.color
        sc.searchBar.placeholder = L.Trackers.SearchBar.placeholder
        sc.searchBar.delegate = self
        return sc
    }()
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = A.Colors.blue.color
        datePicker.locale = .current
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        return datePicker
    }()
    private lazy var filterButton: UIButton = {
        let button = BaseButton()
        button.setTitleColor(A.Colors.white.color, for: .normal)
        button.titleLabel?.font = GlobalConstants.Font.sfPro17
        button.setTitle(L.Filters.title, for: .normal)
        button.backgroundColor = A.Colors.blue.color
        button.addTarget(self, action: #selector(tapFiltersButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        presenter?.viewDidLoad()
        setNeededView()
        trackersView.collectionView.delegate = self
        trackersView.collectionView.dataSource = self

        filterObservation = userDefaults.observe(\.filter, options: []) { [weak self] _, _ in
            guard let self else { return }
            self.reloadCollectionView()
        }

        createNewTrackerCreatedObserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.analyticsService.didOpenMainScreen()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.analyticsService.didCloseMainScreen()
    }

    // MARK: - Public Methods
    func reloadCollectionView(searchText: String? = nil) {
        if let searchText, !searchText.isEmpty {
            presenter?.fetchTrackers(searchText: searchText)
        } else {
            switch currentFilter {
            case .all: presenter?.fetchTrackers(date: currentDate)
            case .today:
                currentDate = Date().stripTime()
                datePicker.date = Date().stripTime()
                presenter?.fetchTrackers(date: currentDate)
            case .completed: presenter?.fetchCompletedTrackers(for: currentDate)
            case .incompleted: presenter?.fetchIncompletedTrackers(for: currentDate)
            }
        }
        setNeededView()
        trackersView.collectionView.reloadData()
    }

    func setDate(date: Date) {
        datePicker.date = date
    }

    // MARK: - Private Methods
    private func setNeededView() {
        var suitableEmptyView: UIView
        switch state {
        case .base:
            suitableEmptyView = emptyView
            showFilterButton(true)
        case .search:
            suitableEmptyView = nothingFoundView
            showFilterButton(false)
        }
        view = presenter?.numberOfSections == 0 ? suitableEmptyView : trackersView
        addFilterButton()
    }

    private func addFilterButton() {
        view.addSubview(filterButton)
        filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.bottomAnchor.constraint(
            equalTo: filterButton.bottomAnchor,
            constant: Constants.FilterButton.bottomInset
        ).isActive = true
    }

    private func configureNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }

        let leftButton = UIBarButtonItem(
            image: A.Icons.Trackers.addTracker.image,
            style: .plain,
            target: self,
            action: #selector(presentCreateTrackerViewController)
        )
        navBar.topItem?.setLeftBarButton(leftButton, animated: false)

        let barButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.setRightBarButton(barButton, animated: false)

        navBar.prefersLargeTitles = true
        navBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: A.Colors.blackDynamic.color
        ]
        navigationItem.title = L.Trackers.title

        navigationItem.searchController = searchController

        navBar.tintColor = A.Colors.blackDynamic.color
    }

    private func createNewTrackerCreatedObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadCollectionView),
                                               name: .didNewTrackerCreated,
                                               object: nil)
    }

    private func pin(indexPath: IndexPath) {
        presenter?.pinTracker(at: indexPath)
    }

    private func unpin(indexPath: IndexPath) {
        presenter?.unpinTracker(at: indexPath)
    }

    private func edit(indexPath: IndexPath) {
        guard let tracker = presenter?.tracker(at: indexPath) else { return }
        let newTrackerPresenter = NewTrackerPresenter(
            type: tracker.type,
            mode: .edit(indexPath: indexPath)
        )
        let newTrackerViewController = NewTrackerViewController()
        newTrackerPresenter.view = newTrackerViewController
        newTrackerViewController.presenter = newTrackerPresenter
        newTrackerPresenter.configureNewTrackerModel(tracker: tracker)
        presenter?.analyticsService.didClickEditTracker()
        present(newTrackerViewController, animated: true)
    }

    private func delete(indexPath: IndexPath) {
        AlertPresenter.show(in: self, model: .trackerDeleteConfirmation { [weak self] in
            self?.presenter?.deleteTracker(at: indexPath)
        })
    }

    func showFilterButton(_ show: Bool) {
        filterButton.isHidden = !show
    }

    @objc private func presentCreateTrackerViewController() {
        let viewController = CreateTrackerViewController()
        presenter?.analyticsService.didClickAddTracker()
        present(viewController, animated: true)
    }

    @objc private func datePickerChanged(picker: UIDatePicker) {
        currentDate = picker.date.stripTime()
        currentFilter = .all
        presenter?.analyticsService.didChangeDate()
        reloadCollectionView()
    }

    @objc private func tapFiltersButton() {
        let viewController = FiltersViewController()
        presenter?.analyticsService.didClickFilters()
        present(viewController, animated: true)
    }

    @objc private func reloadCollectionView() {
        reloadCollectionView(searchText: nil)
    }

}

// MARK: - TrackersNavigationController
final class TrackersNavigationController: UINavigationController {
}

// MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        reloadCollectionView(searchText: searchController.searchBar.text)
    }

}

// MARK: - UISearchControllerDelegate
extension TrackersViewController: UISearchControllerDelegate {
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        state = .search
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        state = .base
    }

}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        presenter?.numberOfItemsInSection(section) ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.numberOfSections ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
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
            for: indexPath) as? BaseSectionTitleView {
            sectionTitleView.titleLabel.text = presenter?.categoryTitle(at: indexPath)
            return sectionTitleView
        }
        return UICollectionReusableView()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let tracker = presenter?.tracker(at: indexPath) else { return nil }
        let pinAction = UIAction(title: L.ContextMenu.pin) { [weak self] _ in
            self?.pin(indexPath: indexPath)
        }
        let unpinAction = UIAction(title: L.ContextMenu.unpin) { [weak self] _ in
            self?.unpin(indexPath: indexPath)
        }
        let pinUnpinAction = tracker.isPinned ? unpinAction : pinAction

        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [
                pinUnpinAction,
                UIAction(title: L.ContextMenu.edit) { [weak self] _ in
                    self?.edit(indexPath: indexPath)
                },
                UIAction(title: L.ContextMenu.delete, attributes: .destructive) { [weak self] _ in
                    self?.delete(indexPath: indexPath)
                }
            ])
        })
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
