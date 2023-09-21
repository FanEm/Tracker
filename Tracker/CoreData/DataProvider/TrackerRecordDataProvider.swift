//
//  TrackerRecordDataProvider.swift
//  Tracker
//

import CoreData

// MARK: - TrackerRecordDataProviderDelegate
protocol TrackerRecordDataProviderDelegate: AnyObject {
    func didUpdate(_ update: StoreUpdate)
}

// MARK: - TrackerRecordDataProviderProtocol
protocol TrackerRecordDataProviderProtocol {
    var numberOfRecords: Int { get }

    func record(with trackerId: UUID, date: Date) -> TrackerRecordCoreData?
    func records(date: Date) -> [TrackerRecordCoreData]
    func recordsCount(with trackerId: UUID) -> Int
    func markTrackerAsCompleted(trackerId: UUID, date: Date)
    func markTrackerAsNotCompleted(trackerId: UUID, date: Date)
    func fetchRecords()
}

// MARK: - TrackerRecordDataProvider
final class TrackerRecordDataProvider: NSObject {

    // MARK: - Public Properties
    weak var delegate: TrackerRecordDataProviderDelegate?

    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private let dataStore: DataStore

    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    private lazy var fetchedResultsController: NSFetchedResultsController = {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerRecordCoreData.date), ascending: true)
        ]
        request.sortDescriptors = sortDescriptors

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
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

// MARK: - TrackerRecordDataProviderProtocol
extension TrackerRecordDataProvider: TrackerRecordDataProviderProtocol {

    // MARK: - Public Properties
    var numberOfRecords: Int {
        dataStore.trackerRecordStore.numberOfRecords
    }

    // MARK: - Public Methods
    func record(with trackerId: UUID, date: Date) -> TrackerRecordCoreData? {
        dataStore.trackerRecordStore.record(with: trackerId, date: date as NSDate)
    }

    func records(date: Date) -> [TrackerRecordCoreData] {
        dataStore.trackerRecordStore.records(for: date.stripTime() as NSDate)
    }

    func recordsCount(with trackerId: UUID) -> Int {
        dataStore.trackerRecordStore.count(with: trackerId)
    }

    func markTrackerAsCompleted(trackerId: UUID, date: Date) {
        guard let tracker = dataStore.trackerStore.tracker(with: trackerId) else { return }
        dataStore.trackerRecordStore.add(tracker: tracker, date: date.stripTime())
    }

    func markTrackerAsNotCompleted(trackerId: UUID, date: Date) {
        guard let record = dataStore
                            .trackerRecordStore
                            .record(with: trackerId, date: date.stripTime() as NSDate),
              let tracker = dataStore.trackerStore.tracker(with: trackerId)
        else { return }
        dataStore.trackerRecordStore.delete(record, tracker: tracker)
    }

    func fetchRecords() {
        try? fetchedResultsController.performFetch()
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordDataProvider: NSFetchedResultsControllerDelegate {

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
