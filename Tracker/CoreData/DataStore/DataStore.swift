//
//  DataStore.swift
//  Tracker
//

import CoreData

// MARK: - DataStoreProtocol
protocol DataStoreProtocol: AnyObject {
    var context: NSManagedObjectContext { get }
    var trackerStore: TrackerStoreProtocol { get }
    var trackerCategoryStore: TrackerCategoryStoreProtocol { get }
    var trackerRecordStore: TrackerRecordStoreProtocol { get }
}

// MARK: - DataStore
final class DataStore: DataStoreProtocol {

    // MARK: - Public Properties
    private(set) var context: NSManagedObjectContext
    private(set) var trackerStore: TrackerStoreProtocol
    private(set) var trackerCategoryStore: TrackerCategoryStoreProtocol
    private(set) var trackerRecordStore: TrackerRecordStoreProtocol

    // MARK: - Private Properties
    private let container: NSPersistentContainer
    private let modelName = "Tracker"
    private let storeURL = NSPersistentContainer
                                .defaultDirectoryURL()
                                .appendingPathComponent("data-store.sqlite")

    // MARK: - Initializers
    // swiftlint:disable force_try
    init() {
        let modelUrl = Bundle(for: DataStore.self).url(forResource: modelName, withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: modelUrl!)!

        self.container = try! NSPersistentContainer.load(name: modelName, model: model, url: storeURL)
        self.context = container.newBackgroundContext()
        self.trackerStore = TrackerStore(context: context)
        self.trackerCategoryStore = TrackerCategoryStore(context: context)
        self.trackerRecordStore = TrackerRecordStore(context: context)
    }

}
