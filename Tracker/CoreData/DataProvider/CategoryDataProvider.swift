//
//  CategoryDataProvider.swift
//  Tracker
//

import CoreData

// MARK: - CategoryDataProviderDelegate
protocol CategoryDataProviderDelegate: AnyObject {
    func didUpdate(_ update: StoreUpdate)
}

// MARK: - CategoryDataProviderProtocol
protocol CategoryDataProviderProtocol {
    var categories: [TrackerCategoryCoreData] { get }
    var numberOfCategories: Int { get }

    func add(category: Category)
    func renameCategory(at indexPath: IndexPath, to newName: String)
    func renameCategory(_ category: TrackerCategoryCoreData, to newName: String)
    func category(at indexPath: IndexPath) -> TrackerCategoryCoreData?
    func category(with type: CategoryType) -> TrackerCategoryCoreData?
    func category(with id: UUID) -> TrackerCategoryCoreData?
    func deleteCategory(at indexPath: IndexPath)
    func fetchCategories()
}

// MARK: - CategoryDataProvider
final class CategoryDataProvider: NSObject {

    // MARK: - Public Properties
    weak var delegate: CategoryDataProviderDelegate?

    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private let dataStore: DataStore

    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    private lazy var fetchedResultsController: NSFetchedResultsController = {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerCategoryCoreData.name), ascending: true)
        ]
        let predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.type),
            NSNumber(value: CategoryType.user.rawValue)
        )
        request.predicate = predicate
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

// MARK: - CategoryDataProviderProtocol
extension CategoryDataProvider: CategoryDataProviderProtocol {

    // MARK: - Public Properties
    var categories: [TrackerCategoryCoreData] {
        dataStore.trackerCategoryStore.categories
    }

    var numberOfCategories: Int {
        dataStore.trackerCategoryStore.numberOfCategories
    }

    // MARK: - Public Methods
    func add(category: Category) {
        dataStore.trackerCategoryStore.add(category)
    }

    func renameCategory(at indexPath: IndexPath, to newName: String) {
        let category = fetchedResultsController.object(at: indexPath)
        dataStore.trackerCategoryStore.rename(category, to: newName)
    }

    func renameCategory(_ category: TrackerCategoryCoreData, to newName: String) {
        dataStore.trackerCategoryStore.rename(category, to: newName)
    }

    func category(at indexPath: IndexPath) -> TrackerCategoryCoreData? {
        fetchedResultsController.object(at: indexPath)
    }

    func category(with type: CategoryType) -> TrackerCategoryCoreData? {
        dataStore.trackerCategoryStore.category(with: type)
    }

    func category(with id: UUID) -> TrackerCategoryCoreData? {
        dataStore.trackerCategoryStore.category(with: id)
    }

    func deleteCategory(at indexPath: IndexPath) {
        let category = fetchedResultsController.object(at: indexPath)
        let pinnedTrackers = dataStore.trackerStore.trackers(with: category.id)
        for pinnedTracker in pinnedTrackers {
            dataStore.trackerStore.delete(pinnedTracker)
        }
        dataStore.trackerCategoryStore.delete(category)
    }

    func fetchCategories() {
        try? fetchedResultsController.performFetch()
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension CategoryDataProvider: NSFetchedResultsControllerDelegate {

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
