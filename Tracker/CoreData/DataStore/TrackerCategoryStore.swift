//
//  TrackerCategoryStore.swift
//  Tracker
//

import CoreData

// MARK: - TrackerCategoryStoreProtocol
protocol TrackerCategoryStoreProtocol: AnyObject {
    var categories: [TrackerCategoryCoreData] { get }
    var numberOfCategories: Int { get }

    func add(_ category: Category)
    func rename(_ category: TrackerCategoryCoreData, to newName: String)
    func delete(_ category: TrackerCategoryCoreData)
    func category(with name: String) -> TrackerCategoryCoreData?
    func category(with type: CategoryType) -> TrackerCategoryCoreData?
    func category(with id: UUID) -> TrackerCategoryCoreData?
}

// MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {

    // MARK: - Private Properties
    private let context: NSManagedObjectContext

    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Private Methods
    private func categoryCoreData(predicate: NSPredicate) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = predicate
        request.fetchLimit = 1

        let categoriesCoreData = try? context.fetch(request)
        return categoriesCoreData?.first
    }

}

// MARK: - TrackerCategoryStoreProtocol
extension TrackerCategoryStore: TrackerCategoryStoreProtocol {

    // MARK: - Public Properties
    var categories: [TrackerCategoryCoreData] {
        let request = TrackerCategoryCoreData.fetchRequest()
        let predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.type),
            NSNumber(value: CategoryType.user.rawValue)
        )
        request.predicate = predicate
        let categories = try? context.fetch(request)
        return categories ?? []
    }

    var numberOfCategories: Int {
        let request = TrackerCategoryCoreData.fetchRequest()
        let predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.type),
            NSNumber(value: CategoryType.user.rawValue)
        )
        request.predicate = predicate
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
    func add(_ category: Category) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.id = category.id
        trackerCategoryCoreData.name = category.name
        trackerCategoryCoreData.type = Int16(category.type.rawValue)
        trackerCategoryCoreData.trackers = NSSet()
        context.saveContext()
    }

    func rename(_ category: TrackerCategoryCoreData, to newName: String) {
        category.name = newName
        context.saveContext()
    }

    func delete(_ category: TrackerCategoryCoreData) {
        context.delete(category)
        context.saveContext()
    }

    func category(with name: String) -> TrackerCategoryCoreData? {
        let predicate = NSPredicate(
            format: "%K MATCHES[cd] %@ AND %K == %@",
            #keyPath(TrackerCategoryCoreData.name), name,
            #keyPath(TrackerCategoryCoreData.type), NSNumber(value: CategoryType.user.rawValue)
        )
        return categoryCoreData(predicate: predicate)
    }

    func category(with type: CategoryType) -> TrackerCategoryCoreData? {
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(TrackerCategoryCoreData.type), NSNumber(value: type.rawValue)
        )
        return categoryCoreData(predicate: predicate)
    }

    func category(with id: UUID) -> TrackerCategoryCoreData? {
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(TrackerCategoryCoreData.id), id as NSUUID
        )
        return categoryCoreData(predicate: predicate)
    }

}
