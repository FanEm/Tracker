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
    func record(with trackerId: UUID, date: Date) -> TrackerRecordCoreData?
    func records(date: Date) -> [TrackerRecordCoreData]
    func recordsCount(with trackerId: UUID) -> Int
    func tracker(at indexPath: IndexPath) -> TrackerCoreData?
    func categoryTitle(at indexPath: IndexPath) -> String
    func add(tracker: Tracker, for categoryName: String)
    func markTrackerAsCompleted(trackerId: UUID, date: Date)
    func markTrackerAsNotCompleted(trackerId: UUID, date: Date)
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

    private var currentWeekDay = Date().dayOfTheWeek()

    private lazy var fetchedResultsController: NSFetchedResultsController = {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerCoreData.category.name), ascending: true),
            NSSortDescriptor(key: #keyPath(TrackerCoreData.name), ascending: true)
        ]
        request.sortDescriptors = sortDescriptors
        
        let predicate = NSPredicate(
            format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.schedule), currentWeekDay.rawValue
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

    func fetchTrackers(searchText: String, weekDay: WeekDay) {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K CONTAINS[cd] %@ AND %K CONTAINS[cd] %@",
            #keyPath(TrackerCoreData.name), searchText,
            #keyPath(TrackerCoreData.schedule), weekDay.rawValue
        )
        try? fetchedResultsController.performFetch()
    }

    func record(with trackerId: UUID, date: Date) -> TrackerRecordCoreData? {
        dataStore.trackerRecordStore.record(with: trackerId, date: date as NSDate)
    }

    func records(date: Date) -> [TrackerRecordCoreData] {
        dataStore.trackerRecordStore.records(for: date.stripTime() as NSDate)
    }

    func recordsCount(with trackerId: UUID) -> Int {
        dataStore.trackerRecordStore.count(with: trackerId)
    }

    func tracker(at indexPath: IndexPath) -> TrackerCoreData? {
        fetchedResultsController.object(at: indexPath)
    }

    func categoryTitle(at indexPath: IndexPath) -> String {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        return trackerCoreData.category.name
    }

    func add(tracker: Tracker, for categoryName: String) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color
        trackerCoreData.id = tracker.id
        trackerCoreData.schedule = tracker.schedule.toString

        guard let categoryCoreData = dataStore.trackerCategoryStore.category(with: categoryName) else {
            return
        }

        dataStore.trackerStore.add(trackerCoreData, to: categoryCoreData)
    }

    func markTrackerAsCompleted(trackerId: UUID, date: Date) {
        dataStore.trackerRecordStore.add(trackerId: trackerId, date: date.stripTime())
    }

    func markTrackerAsNotCompleted(trackerId: UUID, date: Date) {
        guard let record = dataStore.trackerRecordStore.record(with: trackerId, date: date.stripTime() as NSDate)
        else { return }
        dataStore.trackerRecordStore.delete(record)
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
