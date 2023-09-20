//
//  TrackerStore.swift
//  Tracker
//

import CoreData


// MARK: - TrackerStoreProtocol
protocol TrackerStoreProtocol: AnyObject {
    func add(_ tracker: Tracker, to category: TrackerCategoryCoreData)
    func edit(_ trackerCoreData: TrackerCoreData, newTracker: Tracker, newCategory: TrackerCategoryCoreData)
    func edit(_ trackerCoreData: TrackerCoreData, newTracker: Tracker, previousCategoryId: UUID)
    func pin(_ trackerCoreData: TrackerCoreData, pinCategory: TrackerCategoryCoreData)
    func unpin(_ trackerCoreData: TrackerCoreData, previousCategory: TrackerCategoryCoreData)
    func delete(_ trackerCoreData: TrackerCoreData)
    func tracker(with id: UUID) -> TrackerCoreData?
    func trackers(with previousCategoryId: UUID) -> [TrackerCoreData]
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
    func add(_ tracker: Tracker, to category: TrackerCategoryCoreData) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color
        trackerCoreData.id = tracker.id
        trackerCoreData.schedule = tracker.schedule.toString
        trackerCoreData.type = Int16(tracker.type.rawValue)
        trackerCoreData.isPinned = tracker.isPinned
        trackerCoreData.previousCategoryId = nil

        category.addToTrackers(trackerCoreData)

        context.saveContext()
    }

    func edit(
        _ trackerCoreData: TrackerCoreData,
        newTracker: Tracker,
        previousCategoryId: UUID
    ) {
        trackerCoreData.name = newTracker.name
        trackerCoreData.color = newTracker.color
        trackerCoreData.emoji = newTracker.emoji
        trackerCoreData.schedule = newTracker.schedule.toString
        trackerCoreData.previousCategoryId = previousCategoryId

        context.saveContext()
    }

    func edit(
        _ trackerCoreData: TrackerCoreData,
        newTracker: Tracker,
        newCategory: TrackerCategoryCoreData
    ) {
        trackerCoreData.name = newTracker.name
        trackerCoreData.color = newTracker.color
        trackerCoreData.emoji = newTracker.emoji
        trackerCoreData.schedule = newTracker.schedule.toString
        trackerCoreData.category = newCategory

        context.saveContext()
    }
    
    func pin(_ trackerCoreData: TrackerCoreData, pinCategory: TrackerCategoryCoreData) {
        trackerCoreData.previousCategoryId = trackerCoreData.category.id
        trackerCoreData.category = pinCategory
        trackerCoreData.isPinned = true

        context.saveContext()
    }
    
    func unpin(_ trackerCoreData: TrackerCoreData, previousCategory: TrackerCategoryCoreData) {
        trackerCoreData.category = previousCategory
        trackerCoreData.isPinned = false
        trackerCoreData.previousCategoryId = nil

        context.saveContext()
    }

    func delete(_ trackerCoreData: TrackerCoreData) {
        let category = trackerCoreData.category
        category.removeFromTrackers(trackerCoreData)
        context.delete(trackerCoreData)

        context.saveContext()
    }

    func tracker(with id: UUID) -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(TrackerCoreData.id), id as NSUUID
        )
        request.fetchLimit = 1
        request.predicate = predicate

        let tracker = try? context.fetch(request).first
        return tracker
    }

    func trackers(with previousCategoryId: UUID) -> [TrackerCoreData] {
        let request = TrackerCoreData.fetchRequest()
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(TrackerCoreData.previousCategoryId), previousCategoryId as NSUUID
        )
        request.predicate = predicate

        let trackers = try? context.fetch(request)
        return trackers ?? []
    }

}
