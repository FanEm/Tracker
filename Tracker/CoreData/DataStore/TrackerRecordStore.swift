//
//  TrackerRecordStore.swift
//  Tracker
//

import CoreData


// MARK: - TrackerRecordStoreProtocol
protocol TrackerRecordStoreProtocol: AnyObject {
    var numberOfRecords: Int { get }

    func add(tracker: TrackerCoreData, date: Date)
    func delete(_ record: TrackerRecordCoreData, tracker: TrackerCoreData)
    func count(with trackerId: UUID) -> Int
    func records(for date: NSDate) -> [TrackerRecordCoreData]
    func record(with trackerId: UUID, date: NSDate) -> TrackerRecordCoreData?
}


// MARK: - TrackerRecordStore
final class TrackerRecordStore: NSObject {

    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
    }

}


// MARK: - TrackerRecordStoreProtocol
extension TrackerRecordStore: TrackerRecordStoreProtocol {

    // MARK: - Public Properties   
    var numberOfRecords: Int {
        let request = TrackerRecordCoreData.fetchRequest()
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
    func add(tracker: TrackerCoreData, date: Date) {
        let record = TrackerRecordCoreData(context: context)
        record.trackerId = tracker.id
        record.date = date.stripTime()
        tracker.addToRecords(record)
        context.saveContext()
    }

    func delete(_ record: TrackerRecordCoreData, tracker: TrackerCoreData) {
        context.delete(record)
        tracker.removeFromRecords(record)
        context.saveContext()
    }

    func count(with trackerId: UUID) -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerId), trackerId as NSUUID
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

    func records(for date: NSDate) -> [TrackerRecordCoreData] {
        let request = TrackerRecordCoreData.fetchRequest()
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date
        )
        request.predicate = predicate

        let records = try? context.fetch(request)
        return records ?? []
    }

    func record(with trackerId: UUID, date: NSDate) -> TrackerRecordCoreData? {
        let request = TrackerRecordCoreData.fetchRequest()
        let predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            #keyPath(TrackerRecordCoreData.trackerId), trackerId as NSUUID,
            #keyPath(TrackerRecordCoreData.date), date
        )
        request.predicate = predicate
        request.fetchLimit = 1

        let records = try? context.fetch(request)
        return records?.first
    }

}
