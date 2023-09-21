//
//  TrackerRecordCoreData+CoreDataProperties.swift
//  Tracker
//

import CoreData

// MARK: - TrackerRecordCoreData
final class TrackerRecordCoreData: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }

    @NSManaged public var trackerId: UUID
    @NSManaged public var date: Date
    @NSManaged public var tracker: TrackerCoreData
}
