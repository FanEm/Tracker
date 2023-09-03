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

    func add(categoryName: String)
    func category(at indexPath: IndexPath) -> TrackerCategoryCoreData?
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
    func add(categoryName: String) {
        dataStore.trackerCategoryStore.add(categoryName)
    }

    func category(at indexPath: IndexPath) -> TrackerCategoryCoreData? {
        fetchedResultsController.object(at: indexPath)
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
