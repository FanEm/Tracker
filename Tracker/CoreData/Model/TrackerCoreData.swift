//
//  TrackerCoreData.swift
//  Tracker
//

import CoreData


// MARK: - TrackerCoreData
final class TrackerCoreData: NSManagedObject, Identifiable  {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }

    @NSManaged public var color: String
    @NSManaged public var emoji: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var schedule: String
    @NSManaged public var category: TrackerCategoryCoreData
    @NSManaged public var records: NSSet
}
