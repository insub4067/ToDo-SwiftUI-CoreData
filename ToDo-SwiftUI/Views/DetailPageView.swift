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
    @FocusState var isFocused

    var body: some View {

        List {
            Section(header: HStack {
                Text("할일 추가")
                    .foregroundColor(Color.textColor)
                    .opacity(0.5)
                Spacer()
            }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .padding(.vertical, 5)
                .padding(.leading, 15)
                .background(Color.background)
            ) {
                TextField("입력", text: $viewModel.userInput) {
                    viewModel.createTodo(context: managedObjectContext)
                    viewModel.getAllTodos(context: managedObjectContext)
                    isFocused = true
                }
                .foregroundColor(Color.textColor)
                .listRowBackground(Color.background)
                .focused($isFocused)
            }
            Section( header: HStack {
                Text("진행중")
                    .foregroundColor(Color.textColor)
                    .opacity(0.5)
                Spacer()
            }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .padding(.vertical, 5)
                .padding(.leading, 15)
                .background(Color.background)) {
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
                    .foregroundColor(Color.textColor)
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

            Section(header: HStack {
                Text("완료")
                    .foregroundColor(Color.textColor)
                    .opacity(0.5)
                Spacer()
            }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .padding(.vertical, 5)
                .padding(.leading, 15)
                .background(Color.background)) {
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
                    .foregroundColor(Color.textColor)
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
