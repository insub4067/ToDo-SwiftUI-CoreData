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

                        NavigationLink(destination: DetailPageView(category: category)) {
                            Text(category.title ?? "")
                                .opacity(0.8)
                        }
                    }
                }
            }
            .listStyle(.inset)
            .background(Color.background)
            .onAppear {
                viewModel.getAllCategories(context: managedObjectContext)
            }
        }
    }
}


