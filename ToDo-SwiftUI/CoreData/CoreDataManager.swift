//
//  CoreDataManager.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/02.
//

import Foundation
import SwiftUI
import CoreData

enum DataError: Error {
    case FailedToFetchData
}

class CoreDataManager: ObservableObject {

    static let shared = CoreDataManager()
    let container = NSPersistentContainer(name: "DataModel")

    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("FAILED TO SAVE CONTEXT")
        }
    }

    func getAllTodos(of category: CategoryEntity, context: NSManagedObjectContext) -> Array<TodoEntity>? {

        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category.title = %@", category.title ?? "")

        let result = try? context.fetch(fetchRequest)

        return result
    }

    func getAllCategories(context: NSManagedObjectContext) ->  Array<CategoryEntity>? {

        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        return result
    }

    func createTodo(of category: CategoryEntity, task: String, context: NSManagedObjectContext) {

        let todo = TodoEntity(context: context)
        todo.id = UUID()
        todo.task = task
        todo.date = Date()
        todo.isDone = false
        todo.category = category

        save(context: context)
    }

    func createCategory(title: String, context: NSManagedObjectContext) {

        let category = CategoryEntity(context: context)
        category.title = title
        category.date = Date()
        category.id = UUID()

        save(context: context)
    }

    func deleteCategory(category: CategoryEntity, context: NSManagedObjectContext) {

        context.delete(category)
        
        do{
            try context.save()
        } catch {
            print("FAILED TO DELETE DATA")
        }
    }

    func createTodo(task: String, segment: Int, context: NSManagedObjectContext) {

        let todo = TodoEntity(context: context)
        todo.segment = Int64(segment)
        todo.id = UUID()
        todo.task = task
        todo.isDone = false

        save(context: context)
    }

    func deleteTodo(todo: TodoEntity, context: NSManagedObjectContext) {

        context.delete(todo)

        do{
            try context.save()
        } catch {
            print("FAILED TO DELETE DATA")
        }
    }

    func deleteTodos(todos: [TodoEntity], context: NSManagedObjectContext) {

        for todo in todos {
            context.delete(todo)
        }

        do{
            try context.save()
        } catch {
            print("FAILED TO DELETE DATA")
        }
    }

    func editTodo(todo: TodoEntity, context: NSManagedObjectContext) {
        todo.isDone.toggle()
        save(context: context)
    }


}
