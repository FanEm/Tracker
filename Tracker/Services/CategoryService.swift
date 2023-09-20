//
//  CategoryService.swift
//  Tracker
//

import UIKit


// MARK: - CategoryServiceProtocol
protocol CategoryServiceProtocol {
    var dataProviderDelegate: CategoryDataProviderDelegate? { get set }
    var categories: [Category] { get }
    var numberOfCategories: Int { get }

    func add(category: Category)
    func category(at indexPath: IndexPath) -> Category?
    func category(with id: UUID) -> Category?
    func renameCategory(at indexPath: IndexPath, to newName: String)
    func deleteCategory(at indexPath: IndexPath)
    func fetchCategories()
    func createPinCategoryIfNeeded()
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
        dataProvider?.categories.map { Category(categoryCoreData: $0) } ?? []
    }

    var numberOfCategories: Int {
        dataProvider?.numberOfCategories ?? 0
    }

    // MARK: - Public Methods
    func add(category: Category) {
        dataProvider?.add(category: category)
    }

    func renameCategory(at indexPath: IndexPath, to newName: String) {
        dataProvider?.renameCategory(at: indexPath, to: newName)
    }

    func category(at indexPath: IndexPath) -> Category? {
        guard let trackerCategoryCoreData = dataProvider?.category(at: indexPath) else { return nil }
        return Category(categoryCoreData: trackerCategoryCoreData)
    }

    func category(with id: UUID) -> Category? {
        guard let trackerCategoryCoreData = dataProvider?.category(with: id) else { return nil }
        return Category(categoryCoreData: trackerCategoryCoreData)
    }

    func createPinCategoryIfNeeded() {
        let pinnedCategoryName = L.Category.pinned
        let category = dataProvider?.category(with: .pin)
        if category == nil {
            dataProvider?.add(category: Category(id: UUID(), name: pinnedCategoryName, type: .pin))
            return
        }
        if let category, category.name != pinnedCategoryName {
            dataProvider?.renameCategory(category, to: pinnedCategoryName)
        }
    }

    func deleteCategory(at indexPath: IndexPath) {
        dataProvider?.deleteCategory(at: indexPath)
    }

    func fetchCategories() {
        dataProvider?.fetchCategories()
    }

}
