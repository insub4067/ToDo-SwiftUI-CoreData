//
//  ContentView.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/02.
//

import SwiftUI
import Combine
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject var viewModel = ContentViewModel()
    @FocusState var isFocused

    let coreDataManager = CoreDataManager()

    init() {
        UITableView.appearance().backgroundColor = UIColor(Color.background)
    }

    var body: some View {

        NavigationView {
            List {
                Section("카테고리 추가") {
                    TextField("입력", text: $viewModel.userInput) {
                        viewModel.createCategory(context: managedObjectContext)
                        viewModel.getAllCategories(context: managedObjectContext)
                    }
                    .listRowBackground(Color.background)
                }


                Section("카테고리 목록") {
                    ForEach(viewModel.categoryList, id: \.self) { category in

                        ZStack{
                            NavigationLink(category.title ?? "", destination: DetailPageView(category: category))
                            .opacity(0)

                            HStack{
                                Text(category.title ?? "")
                                    .opacity(0.8)
                                Spacer()
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {

                            // Category 삭제 버튼
                            Button {
                                viewModel.selectedCategory = category
                                viewModel.isAlertShowing = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)

                            // Category 수정 버튼
                            Button {
                                viewModel.selectedCategory = category
                                customAlert() { userInput in
                                    viewModel.editCategory(title: userInput, category: category, context: managedObjectContext)
                                    viewModel.getAllCategories(context: managedObjectContext)
                                } secondaryAction: {
                                    print("DEBUG")
                                }

                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .tint(.yellow)
                        }
                    }
                }
                .navigationBarTitle("카테고리")
                .listRowBackground(Color.background)
                .alert(isPresented: $viewModel.isAlertShowing, content: {
                    Alert(title: Text("삭제 하시겠습니까?"), primaryButton: .destructive(Text("삭제")) {
                        viewModel.deleteCategory(category: viewModel.selectedCategory, context: managedObjectContext)
                        viewModel.getAllCategories(context: managedObjectContext)
                    }, secondaryButton: .cancel(Text("취소")))
                })
            }
            .listStyle(.inset)
            .onAppear {
                viewModel.getAllCategories(context: managedObjectContext)
                viewModel.getAllCategories(context: managedObjectContext)
            }
        }
    }
}


