//
//  CoreDataManager.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/02.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {

    static let shared = CoreDataManager()
    let container = NSPersistentContainer(name: "DataModel")

    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("FAILED TO SAVE CONTEXT")
        }
    }

    func addTodo(task: String, context: NSManagedObjectContext) {

        let todo = TodoEntity(context: context)
        todo.uuid = UUID()
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

    func deleteArrayOfTodo(todos: [TodoEntity], context: NSManagedObjectContext) {


        for todo in todos {
            context.delete(todo)
        }

        do{
             try context.save()
         } catch {
             print("FAILED TO DELETE DATA")
         }
    }

    func editTodo(todo: TodoEntity, isDone: Bool, context: NSManagedObjectContext) {
        todo.isDone = isDone
        save(context: context)
    }


}
