//
//  ListView.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/02.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    let todoList: FetchedResults<TodoEntity>
    let segmentIndex: Int

    let coreDataManager = CoreDataManager.shared

    @State private var currentText = ""
    @FocusState private var isFocused: Bool

    var body: some View {

        let taskList = todoList.filter { todo in
            todo.isDone == false
        }

        let doneTaskList = todoList.filter { todo in
            todo.isDone == true
        }

        List {
            Section("할일") {
                TextField("입력", text: $currentText) {
                    coreDataManager.addTodo(task: currentText, segment: segmentIndex, context: managedObjectContext)
                    currentText = ""
                }
                .focused($isFocused)
                .textFieldStyle(.roundedBorder)
                ForEach(taskList) { todo in
                    HStack{
                        Button {
                            withAnimation {
                                coreDataManager.editTodo(todo: todo, isDone: !todo.isDone, context: managedObjectContext)
                            }
                        } label: {
                            Image(systemName: todo.isDone ? "checkmark.square.fill" : "checkmark.square")
                                .opacity(0.3)
                        }
                        .tint(.black)
                        .padding(.trailing, 5)
                        Text(todo.task ?? "")
                    }
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            coreDataManager.deleteTodo(todo: todo, context: managedObjectContext)
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        .tint(.red)
                    }
                }
            }

            Section("완료") {
                ForEach(doneTaskList) { todo in
                    HStack{
                        Button {
                            withAnimation {
                                coreDataManager.editTodo(todo: todo, isDone: !todo.isDone, context: managedObjectContext)
                            }
                        } label: {
                            Image(systemName: todo.isDone ? "checkmark.square.fill" : "checkmark.square")
                                .opacity(0.5)
                        }
                        .tint(.black)
                        .padding(.trailing, 5)

                        Text(todo.task ?? "")
                            .strikethrough()
                    }
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            coreDataManager.deleteTodo(todo: todo, context: managedObjectContext)
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: ToolbarItemPlacement.keyboard) {
                Button("") {}
                Button("닫기") { isFocused = false } 
            }
        }
    }
}
