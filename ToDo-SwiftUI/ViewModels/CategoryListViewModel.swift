//
//  ContentViewModel.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/03.
//

import SwiftUI
import Combine
import CoreData

final class CategoryListViewModel: ObservableObject {

    @Published var userInput = ""
    @Published var categoryList: Array<CategoryEntity> = []
    @Published var selectedCategory: CategoryEntity? = nil
    @Published var isAlertShowing = false

    func viewDidAppear(context: NSManagedObjectContext) {
        getAllCategories(context: context)
    }

    func didSubmitTextField(context: NSManagedObjectContext) {
        createCategory(context: context)
        getAllCategories(context: context)
    }

    func didTapDeleteButton(category: CategoryEntity) {
        selectedCategory = category
        isAlertShowing = true
    }

    func didAllowDeletion(context: NSManagedObjectContext) {
        deleteCategory(context: context)
        getAllCategories(context: context)
    }

    func didTapEditButton(newValue: String, category: CategoryEntity, context: NSManagedObjectContext) {
        editCategory(title: newValue, category: category, context: context)
        getAllCategories(context: context)
    }
}

extension CategoryListViewModel {

    func getAllCategories(context: NSManagedObjectContext) {
        let response = CoreDataManager
            .shared
            .getAllCategories(
                context: context
            )
        categoryList = response ?? [CategoryEntity()]
    }

    func createCategory(context: NSManagedObjectContext) {
        CoreDataManager
            .shared
            .createCategory(
                title: userInput,
                context: context
            )
        userInput = ""
    }

    func deleteCategory(context: NSManagedObjectContext) {
        CoreDataManager
            .shared
            .deleteCategory(
                category: selectedCategory ?? CategoryEntity(),
                context: context
            )
    }

    func editCategory(title: String, category: CategoryEntity, context: NSManagedObjectContext) {
        CoreDataManager
            .shared
            .editCategory(
                title: title,
                category: category,
                context: context
            )
    }
}
