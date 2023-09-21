//
//  TrackersDataProvider.swift
//  Tracker
//

import CoreData

// MARK: - TrackersDataProviderDelegate
protocol TrackersDataProviderDelegate: AnyObject {
    func didUpdate(_ update: StoreUpdate)
}

// MARK: - TrackersDataProviderProtocol
protocol TrackersDataProviderProtocol {
    var numberOfSections: Int { get }

    func numberOfItemsInSection(_ section: Int) -> Int
    func fetchTrackers(weekDay: WeekDay)
    func fetchTrackers(searchText: String, weekDay: WeekDay)
    func fetchCompletedTrackers(for date: Date)
    func fetchIncompletedTrackers(for date: Date)
    func tracker(at indexPath: IndexPath) -> TrackerCoreData?
    func deleteTracker(at indexPath: IndexPath)
    func editTracker(at indexPath: IndexPath, newTracker: Tracker)
    func pinTracker(at indexPath: IndexPath)
    func unpinTracker(at indexPath: IndexPath)
    func categoryTitle(at indexPath: IndexPath) -> String
    func add(tracker: Tracker)
}

// MARK: - TrackersDataProvider
final class TrackersDataProvider: NSObject {

    // MARK: - Public Properties
    weak var delegate: TrackersDataProviderDelegate?

    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private let dataStore: DataStore

    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    private var currentWeekDay = Date().dayOfTheWeek

    private lazy var fetchedResultsController: NSFetchedResultsController = {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerCoreData.category.type), ascending: false),
            NSSortDescriptor(key: #keyPath(TrackerCoreData.category.name), ascending: true),
            NSSortDescriptor(key: #keyPath(TrackerCoreData.name), ascending: true)
        ]
        request.sortDescriptors = sortDescriptors

        let predicate = NSPredicate(
            format: "%K CONTAINS[cd] %@",
            #keyPath(TrackerCoreData.schedule), currentWeekDay.rawValue
        )
        request.predicate = predicate

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.name),
            cacheName: nil
        )

        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    // MARK: - Initializers
    init(dataStore: DataStore) {
        self.context = dataStore.context
        self.dataStore = dataStore
    }
}

// MARK: - TrackersDataProviderProtocol
extension TrackersDataProvider: TrackersDataProviderProtocol {

    // MARK: - Public Properties
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }

    // MARK: - Public Methods
    func numberOfItemsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func fetchTrackers(weekDay: WeekDay) {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.schedule), weekDay.rawValue
        )
        try? fetchedResultsController.performFetch()
    }

    func fetchCompletedTrackers(for date: Date) {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K CONTAINS[cd] %@ "
            + "AND %K.@count > 0 "
            + "AND SUBQUERY(records, $record, $record.date == %@).@count > 0",
            #keyPath(TrackerCoreData.schedule), date.dayOfTheWeek.rawValue,
            #keyPath(TrackerCoreData.records), date.stripTime() as NSDate
        )
        try? fetchedResultsController.performFetch()
    }

    func fetchIncompletedTrackers(for date: Date) {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K CONTAINS[cd] %@ "
            + "AND %K.@count == 0 "
            + "AND SUBQUERY(records, $record, $record.date == %@).@count == 0",
            #keyPath(TrackerCoreData.schedule), date.dayOfTheWeek.rawValue,
            #keyPath(TrackerCoreData.records), date.stripTime() as NSDate
        )
        try? fetchedResultsController.performFetch()
    }

    func fetchTrackers(searchText: String, weekDay: WeekDay) {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K CONTAINS[cd] %@ AND %K CONTAINS[cd] %@",
            #keyPath(TrackerCoreData.name), searchText,
            #keyPath(TrackerCoreData.schedule), weekDay.rawValue
        )
        try? fetchedResultsController.performFetch()
    }

    func tracker(at indexPath: IndexPath) -> TrackerCoreData? {
        fetchedResultsController.object(at: indexPath)
    }

    func categoryTitle(at indexPath: IndexPath) -> String {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        return trackerCoreData.category.name
    }

    func add(tracker: Tracker) {
        let categoryName = tracker.category.name
        guard let categoryCoreData = dataStore.trackerCategoryStore.category(with: categoryName) else {
            return
        }
        dataStore.trackerStore.add(tracker, to: categoryCoreData)
    }

    func editTracker(at indexPath: IndexPath, newTracker: Tracker) {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        let newCategoryId = newTracker.category.id

        guard newTracker != Tracker(trackerCoreData: trackerCoreData),
              let newCategoryCoreData = dataStore.trackerCategoryStore.category(with: newCategoryId)
        else { return }

        if trackerCoreData.isPinned {
            dataStore.trackerStore.edit(
                trackerCoreData,
                newTracker: newTracker,
                previousCategoryId: newCategoryId
            )
        } else {
            dataStore.trackerStore.edit(
                trackerCoreData,
                newTracker: newTracker,
                newCategory: newCategoryCoreData
            )
        }
    }

    func pinTracker(at indexPath: IndexPath) {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        guard let pinCategoryCoreData = dataStore.trackerCategoryStore.category(with: .pin) else { return }

        dataStore.trackerStore.pin(trackerCoreData, pinCategory: pinCategoryCoreData)
    }

    func unpinTracker(at indexPath: IndexPath) {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        guard let previousCategoryId = trackerCoreData.previousCategoryId,
              let previousCategory = dataStore.trackerCategoryStore.category(with: previousCategoryId)
        else { return }
        dataStore.trackerStore.unpin(trackerCoreData, previousCategory: previousCategory)
    }

    func deleteTracker(at indexPath: IndexPath) {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        dataStore.trackerStore.delete(trackerCoreData)
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackersDataProvider: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.didUpdate(StoreUpdate(insertedIndexes: insertedIndexes!,
                                        deletedIndexes: deletedIndexes!))
        insertedIndexes = nil
        deletedIndexes = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }

}
