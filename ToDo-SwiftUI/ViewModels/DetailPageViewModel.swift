//
//  DetailPageViewModel.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/04.
//

import Foundation
import Combine
import CoreData

final class DetailPageViewModel: ObservableObject {

    @Published var userInput = ""
    @Published var todoList: Array<TodoEntity> = []
    @Published var inProgressTodos: Array<TodoEntity> = []
    @Published var doneTodos: Array<TodoEntity> = []

    var category = CategoryEntity()

    func getAllTodos(context: NSManagedObjectContext) {
        
        let response = CoreDataManager.shared.getAllTodos(of: category, context: context)
        todoList = response ?? [TodoEntity()]

        inProgressTodos = todoList.filter({ todo in
            todo.isDone == false
        })

        doneTodos = todoList.filter({ todo in
            todo.isDone == true
        })
    }

    func editTodo(todo: TodoEntity, context: NSManagedObjectContext) {

        CoreDataManager.shared.editTodo(todo: todo, context: context)
    }

    func createTodo(context: NSManagedObjectContext) {
        CoreDataManager.shared.createTodo(of: category, task: userInput, context: context)
        userInput = ""
    }

    func deleteTodo(todo: TodoEntity, context: NSManagedObjectContext) {
        CoreDataManager.shared.deleteTodo(todo: todo, context: context)
        getAllTodos(context: context)
    }
}
