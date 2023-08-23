//
//  TrackerCategoryStore.swift
//  Tracker
//

import CoreData


// MARK: - TrackerCategoryStoreProtocol
protocol TrackerCategoryStoreProtocol: AnyObject {
    var categories: [TrackerCategoryCoreData] { get }
    var numberOfCategories: Int { get }

    func add(_ categoryName: String)
    func category(with name: String) -> TrackerCategoryCoreData?
}


// MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {

    // MARK: - Private Properties
    private let context: NSManagedObjectContext

    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
    }

}


// MARK: - TrackerCategoryStoreProtocol
extension TrackerCategoryStore: TrackerCategoryStoreProtocol {

    // MARK: - Public Properties
    var categories: [TrackerCategoryCoreData] {
        let request = TrackerCategoryCoreData.fetchRequest()
        let categories = try? context.fetch(request)
        return categories ?? []
    }

    var numberOfCategories: Int {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.resultType = .countResultType

        let result = try? context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>
        guard
            let result,
            let count = result.finalResult?.first as? Int
        else {
            return 0
        }

        return count
    }

    // MARK: - Public Methods
    func add(_ categoryName: String) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.name = categoryName
        trackerCategoryCoreData.trackers = NSSet()
        context.saveContext()
    }

    func category(with name: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let predicate = NSPredicate(
            format: "%K MATCHES[cd] %@", #keyPath(TrackerCategoryCoreData.name), name
        )
        request.predicate = predicate
        request.fetchLimit = 1

        let categoriesCoreData = try? context.fetch(request)
        return categoriesCoreData?.first
    }

}
