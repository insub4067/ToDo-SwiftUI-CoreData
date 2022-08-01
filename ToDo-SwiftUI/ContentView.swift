//
//  ContentView.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/02.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.isDone, order: .reverse)]) var todos: FetchedResults<TodoEntity>

    @State private var textField = ""
    @State private var keybaordHeigh: CGFloat = 0.0
    @State private var isShowSheet = false
    @FocusState private var isFocused: Bool

    let coreDataManager = CoreDataManager.shared

    var body: some View {

        let taskList = todos.filter { todo in
            todo.isDone == false
        }

        let doneTaskList = todos.filter { todo in
            todo.isDone == true
        }

        ZStack {
            NavigationView {
                VStack {
                    List {
                        Section("할일") {
                            ForEach(taskList) { todo in
                                HStack{
                                    Button {
                                        coreDataManager.editTodo(todo: todo, isDone: !todo.isDone, context: managedObjectContext)
                                    } label: {
                                        Image(systemName: todo.isDone ? "checkmark.square.fill" : "checkmark.square")
                                            .opacity( todo.isDone ? 1.0 : 0.3 )
                                    }
                                    .tint(.black)
                                    .padding(.trailing, 5)

                                    Text(todo.task ?? "")
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
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
                                        coreDataManager.editTodo(todo: todo, isDone: !todo.isDone, context: managedObjectContext)
                                    } label: {
                                        Image(systemName: todo.isDone ? "checkmark.square.fill" : "checkmark.square")
                                            .opacity( todo.isDone ? 1.0 : 0.3 )
                                    }
                                    .tint(.black)
                                    .padding(.trailing, 5)

                                    Text(todo.task ?? "")
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
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
                    .toolbar{
                        ToolbarItem(placement: ToolbarItemPlacement.principal) {
                            Text("투두리스트")
                        }
                        ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                            Button {
                                isShowSheet.toggle()
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                        }
                    }
                }
            }
            VStack{
                Spacer()
                TextField("입력", text: $textField) {
                    coreDataManager.addTodo(task: textField, context: managedObjectContext)
                    textField = ""
                }
                .focused($isFocused)
                .textFieldStyle(.roundedBorder)
                .offset(y: -self.keybaordHeigh)
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") { isFocused = false }
                }
            }

        }
        .confirmationDialog("삭제할 내용을 선택하세요", isPresented: self.$isShowSheet, titleVisibility: .visible) {
            Button("모두", role: .destructive){
                coreDataManager.deleteArrayOfTodo(todos: Array(todos), context: managedObjectContext)
            }
            Button("할일"){
                coreDataManager.deleteArrayOfTodo(todos: taskList, context: managedObjectContext)
            }
            Button("완료"){
                coreDataManager.deleteArrayOfTodo(todos: doneTaskList, context: managedObjectContext)
            }
        }
    }
}
