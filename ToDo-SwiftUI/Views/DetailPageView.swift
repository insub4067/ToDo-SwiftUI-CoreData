//
//  DetailPageView.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/04.
//

import SwiftUI

struct DetailPageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    init(category: CategoryEntity) {
        viewModel.category = category
    }
    
    @ObservedObject var viewModel = DetailPageViewModel()

    var body: some View {

        List {
            Section("할일 추가") {
                TextField("입력", text: $viewModel.userInput) {
                    viewModel.createTodo(context: managedObjectContext)
                    viewModel.getAllTodos(context: managedObjectContext)
                }
                .listRowBackground(Color.background)
            }
            Section("진행중") {
                ForEach(viewModel.inProgressTodos) { todo in

                    HStack {
                        Button {
                            withAnimation {
                                viewModel.editTodo(todo: todo, context: managedObjectContext)
                                viewModel.getAllTodos(context: managedObjectContext)
                            }
                        } label: {
                            Image(systemName: "square")
                        }
                        Text(todo.task ?? "")
                    }
                    .opacity(0.8)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            viewModel.deleteTodo(todo: todo, context: managedObjectContext)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
                .listRowBackground(Color.background)
            }

            Section("완료") {
                ForEach(viewModel.doneTodos) { todo in

                    HStack {
                        Button {
                            withAnimation {
                                viewModel.editTodo(todo: todo, context: managedObjectContext)
                                viewModel.getAllTodos(context: managedObjectContext)
                            }
                        } label: {
                            Image(systemName: "checkmark.square")
                        }
                        Text(todo.task ?? "")
                            .strikethrough()
                    }
                    .opacity(0.6)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            viewModel.deleteTodo(todo: todo, context: managedObjectContext)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
                .listRowBackground(Color.background)
            }
        }
        .navigationBarTitle(viewModel.category.title ?? "")
        .listStyle(.inset)
        .onAppear{
            viewModel.getAllTodos(context: managedObjectContext)
        }
    }
}
