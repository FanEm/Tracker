//
//  TrackerService.swift
//  Tracker
//

import Foundation
import UIKit


// MARK: - TrackerServiceProtocol
protocol TrackerServiceProtocol {
    var numberOfSections: Int { get }
    var dataProviderDelegate: DataProviderDelegate? { get set }
    var categories: [Category] { get }
    var numberOfCategories: Int { get }

    func numberOfItemsInSection(_ section: Int) -> Int
    func tracker(at indexPath: IndexPath) -> Tracker?
    func categoryTitle(at indexPath: IndexPath) -> String?
    func add(tracker: Tracker, for categoryName: String)
    func add(categoryName: String)
    func markTrackerAsCompleted(trackerId: UUID, date: Date)
    func markTrackerAsNotCompleted(trackerId: UUID, date: Date)
    func fetchTrackers(weekDay: WeekDay)
    func fetchTrackers(searchText: String, weekDay: WeekDay)
    func records(date: Date) -> [TrackerRecord]
    func record(with trackerId: UUID, date: Date) -> TrackerRecord?
    func recordsCount(with trackerId: UUID) -> Int
}


// MARK: - TrackerService
final class TrackerService {

    // MARK: - Public Properties
    static var shared: TrackerServiceProtocol = TrackerService()

    var dataProviderDelegate: DataProviderDelegate? {
        didSet {
            dataProvider?.delegate = dataProviderDelegate
        }
    }

    // MARK: - Private Properties
    private let dataProvider: DataProvider?


    // MARK: - Initializers
    private init(dataProvider: DataProvider?) {
        self.dataProvider = dataProvider
    }

    private convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dataStore = appDelegate.dataStore
        self.init(dataProvider: DataProvider(dataStore: dataStore))
    }

}


// MARK: - TrackerServiceProtocol
extension TrackerService: TrackerServiceProtocol {

    // MARK: - Public Properties
    var numberOfSections: Int {
        dataProvider?.numberOfSections ?? 0
    }

    var categories: [Category] {
        dataProvider?.categories.map { Category(name: $0.name) } ?? []
    }
    
    var numberOfCategories: Int {
        dataProvider?.numberOfCategories ?? 0
    }

    
    // MARK: - Public Methods
    func numberOfItemsInSection(_ section: Int) -> Int {
        dataProvider?.numberOfItemsInSection(section) ?? 0
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        guard let trackerCoreData = dataProvider?.tracker(at: indexPath) else { return nil }
        return Tracker(trackerCoreData: trackerCoreData)
    }
    
    func categoryTitle(at indexPath: IndexPath) -> String? {
        dataProvider?.categoryTitle(at: indexPath)
    }
    
    func add(tracker: Tracker, for categoryName: String) {
        dataProvider?.add(tracker: tracker, for: categoryName)
    }
    
    func add(categoryName: String) {
        dataProvider?.add(categoryName: categoryName)
    }
    
    func markTrackerAsCompleted(trackerId: UUID, date: Date) {
        dataProvider?.markTrackerAsCompleted(trackerId: trackerId, date: date)
    }
    
    func markTrackerAsNotCompleted(trackerId: UUID, date: Date) {
        dataProvider?.markTrackerAsNotCompleted(trackerId: trackerId, date: date)
    }
    
    func fetchTrackers(weekDay: WeekDay) {
        dataProvider?.fetchTrackers(weekDay: weekDay)
    }
    
    func fetchTrackers(searchText: String, weekDay: WeekDay) {
        dataProvider?.fetchTrackers(searchText: searchText, weekDay: weekDay)
    }
    
    func records(date: Date) -> [TrackerRecord] {
        let trackerRecordsCoreData = dataProvider?.records(date: date) ?? []
        return trackerRecordsCoreData.map { TrackerRecord(trackerRecordCoreData: $0) }
    }
    
    func record(with trackerId: UUID, date: Date) -> TrackerRecord? {
        guard let trackerRecordCoreData = dataProvider?.record(with: trackerId, date: date) else { return nil }
        return TrackerRecord(trackerRecordCoreData: trackerRecordCoreData)
    }
    
    func recordsCount(with trackerId: UUID) -> Int {
        dataProvider?.recordsCount(with: trackerId) ?? 0
    }
}
