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
    @State var isAlertShowing = false
    @FocusState var isFocused

    let coreDataManager = CoreDataManager()

    var body: some View {

        NavigationView {
            List {
                Section("추가") {
                    TextField("입력", text: $viewModel.userInput) {
                        viewModel.createCategory(context: managedObjectContext)
                        viewModel.getAllCategories(context: managedObjectContext)
                    }
                    .focused($isFocused)
                }


                Section("카테고리 목록") {
                    ForEach(viewModel.categoryList, id: \.self) { category in

                        ZStack{
                            NavigationLink(category.title ?? "", destination: DetailPageView(category: category))
                            .opacity(0)
                            .navigationBarTitle("")

                            HStack{
                                Text(category.title ?? "")
                                    .opacity(0.8)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: { indexes in
                        for index in indexes {
                            isAlertShowing = true
                            viewModel.deletionIndex = index
                        }
                    })
                }
                .alert(isPresented: $isAlertShowing, content: {
                    Alert(title: Text("삭제 하시겠습니까?"), primaryButton: .destructive(Text("삭제")) {
                        viewModel.deleteCategory(category: viewModel.categoryList[viewModel.deletionIndex], context: managedObjectContext)
                        viewModel.getAllCategories(context: managedObjectContext)
                    }, secondaryButton: .cancel(Text("취소")))
                })
            }
            .listStyle(.inset)
            .background(Color.background)
            .onAppear {
                viewModel.getAllCategories(context: managedObjectContext)
                viewModel.getAllCategories(context: managedObjectContext)
            }
        }
    }
}


