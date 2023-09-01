//
//  CategoryService.swift
//  Tracker
//


import Foundation
import UIKit


// MARK: - CategoryServiceProtocol
protocol CategoryServiceProtocol {
    var dataProviderDelegate: CategoryDataProviderDelegate? { get set }
    var categories: [Category] { get }
    var numberOfCategories: Int { get }

    func add(categoryName: String)
    func category(at indexPath: IndexPath) -> Category?
    func fetchCategories()
}


// MARK: - CategoryService
final class CategoryService {

    // MARK: - Public Properties
    static var shared: CategoryServiceProtocol = CategoryService()

    var dataProviderDelegate: CategoryDataProviderDelegate? {
        didSet {
            dataProvider?.delegate = dataProviderDelegate
        }
    }

    // MARK: - Private Properties
    private let dataProvider: CategoryDataProvider?


    // MARK: - Initializers
    private init(dataProvider: CategoryDataProvider?) {
        self.dataProvider = dataProvider
    }

    private convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dataStore = appDelegate.dataStore
        self.init(dataProvider: CategoryDataProvider(dataStore: dataStore))
    }

}

// MARK: - CategoryServiceProtocol
extension CategoryService: CategoryServiceProtocol {

    // MARK: - Public Properties
    var categories: [Category] {
        dataProvider?.categories.map { Category(name: $0.name) } ?? []
    }

    var numberOfCategories: Int {
        dataProvider?.numberOfCategories ?? 0
    }

    // MARK: - Public Methods
    func add(categoryName: String) {
        dataProvider?.add(categoryName: categoryName)
    }

    func category(at indexPath: IndexPath) -> Category? {
        guard let trackerCategoryCoreData = dataProvider?.category(at: indexPath) else { return nil }
        return Category(name: trackerCategoryCoreData.name)
    }

    func fetchCategories() {
        dataProvider?.fetchCategories()
    }

}
