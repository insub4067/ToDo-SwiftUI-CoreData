//
//  ContentViewModel.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/03.
//

import Foundation
import SwiftUI
import Combine
import CoreData

final class ContentViewModel: ObservableObject {

    @Published var userInput = ""
    @Published var categoryList: Array<CategoryEntity> = []
    @Published var selectedCategory = CategoryEntity()

    func getAllCategories(context: NSManagedObjectContext) {

        let response = CoreDataManager.shared.getAllCategories(context: context)
        categoryList = response ?? [CategoryEntity()]
    }

    func createCategory(context: NSManagedObjectContext) {

        CoreDataManager.shared.createCategory(title: userInput, context: context)
        userInput = ""
    }

    func deleteCategory(category: CategoryEntity, context: NSManagedObjectContext) {

        CoreDataManager.shared.deleteCategory(category: category, context: context)
    }
}
