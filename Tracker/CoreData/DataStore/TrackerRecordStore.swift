//
//  TrackerRecordStore.swift
//  Tracker
//

import CoreData


// MARK: - TrackerRecordStoreProtocol
protocol TrackerRecordStoreProtocol: AnyObject {
    func add(trackerId: UUID, date: Date)
    func delete(_ record: TrackerRecordCoreData)
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

    // MARK: - Public Methods
    func add(trackerId: UUID, date: Date) {
        let record = TrackerRecordCoreData(context: context)
        record.trackerId = trackerId
        record.date = date.stripTime()
        context.saveContext()
    }

    func delete(_ record: TrackerRecordCoreData) {
        context.delete(record)
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
