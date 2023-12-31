//
//  TrackerCategoryCoreData+CoreDataProperties.swift
//  Tracker
//

import CoreData

// MARK: - TrackerCategoryCoreData
final class TrackerCategoryCoreData: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCategoryCoreData> {
        return NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var type: Int16
    @NSManaged public var trackers: NSSet

}

// MARK: Generated accessors for trackers
extension TrackerCategoryCoreData {

    @objc(addTrackersObject:)
    @NSManaged public func addToTrackers(_ value: TrackerCoreData)

    @objc(removeTrackersObject:)
    @NSManaged public func removeFromTrackers(_ value: TrackerCoreData)

    @objc(addTrackers:)
    @NSManaged public func addToTrackers(_ values: NSSet)

    @objc(removeTrackers:)
    @NSManaged public func removeFromTrackers(_ values: NSSet)

}
