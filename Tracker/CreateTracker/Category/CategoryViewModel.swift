//
//  CategoryViewModel.swift
//  Tracker
//

import UIKit


// MARK: - CategoryViewModel
final class CategoryViewModel {

    // MARK: - Public Properties
    @Observable
    private(set) var categories: [Category] = []

    var numberOfCategories: Int {
        categoryService.numberOfCategories
    }

    var categoriesExist: Bool {
        numberOfCategories > 0
    }
    
    var selectedCategory: Category?

    // MARK: - Private Properties
    private var categoryService: CategoryServiceProtocol

    // MARK: - Initializers
    init(categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
        self.categoryService.dataProviderDelegate = self
        fetchCategories()
    }

    convenience init() {
        self.init(categoryService: CategoryService.shared)
    }

    // MARK: - Public Methods
    func fetchCategories() {
        categoryService.fetchCategories()
        categories = categoryService.categories
    }

    func category(at indexPath: IndexPath) -> Category? {
        categoryService.category(at: indexPath)
    }

    func add(category: Category) {
        categoryService.add(category: category)
    }
    
    func isCategoryExists(categoryName: String) -> Bool {
        !categories.filter({ $0.name == categoryName }).isEmpty
    }

    func renameCategory(at indexPath: IndexPath, to newName: String) {
        categoryService.renameCategory(at: indexPath, to: newName)
    }

    func deleteCategory(at indexPath: IndexPath) {
        categoryService.deleteCategory(at: indexPath)
    }

    func configCell(in tableView: UITableView, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        tableView.visibleCells.forEach { $0.accessoryType = .none }
        cell.accessoryType = .checkmark
    }

    func isCategorySelected(_ category: Category) -> Bool {
        return category == selectedCategory
    }

}


// MARK: - CategoryDataProviderDelegate
extension CategoryViewModel: CategoryDataProviderDelegate {

    func didUpdate(_ update: StoreUpdate) {
        fetchCategories()
    }

}
