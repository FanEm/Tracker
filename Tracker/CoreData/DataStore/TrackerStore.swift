//
//  TrackerStore.swift
//  Tracker
//

import CoreData


// MARK: - TrackerStoreProtocol
protocol TrackerStoreProtocol: AnyObject {
    func add(_ tracker: TrackerCoreData, to category: TrackerCategoryCoreData)
}


// MARK: - TrackerStore
final class TrackerStore: NSObject {

    // MARK: - Private Properties
    private let context: NSManagedObjectContext

    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
    }

}


// MARK: - TrackerStoreProtocol
extension TrackerStore: TrackerStoreProtocol {

    // MARK: - Public Methods
    func add(_ tracker: TrackerCoreData, to category: TrackerCategoryCoreData) {
        category.addToTrackers(tracker)
        context.saveContext()
    }

}
