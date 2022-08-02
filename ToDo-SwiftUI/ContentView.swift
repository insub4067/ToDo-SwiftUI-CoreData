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

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.isDone, order: .reverse)],
        predicate: NSPredicate(format: "segment == \(0)")
    ) var firstTodoList: FetchedResults<TodoEntity>

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.isDone, order: .reverse)],
        predicate: NSPredicate(format: "segment == \(1)")
    ) var secondTodoList: FetchedResults<TodoEntity>

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.isDone, order: .reverse)],
        predicate: NSPredicate(format: "segment == \(2)")
    ) var thirdTodoList: FetchedResults<TodoEntity>

    @State private var isSheetShowing: Bool = false
    @State private var segmentIndex = 0

    @AppStorage("할일1") var firstSegment: String = "할일1"
    @AppStorage("할일2") var secondSegment: String = "할일2"
    @AppStorage("할일3") var thirdSegment: String = "할일3"

    let coreDataManager = CoreDataManager.shared

    var body: some View {

        NavigationView {
            VStack {
                Picker("영역 구분", selection: $segmentIndex) {
                    Text(firstSegment).tag(0)
                    Text(secondSegment).tag(1)
                    Text(thirdSegment).tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if segmentIndex == 0 {
                    ListView(todoList: firstTodoList, segmentIndex: segmentIndex)
                }
                else if segmentIndex == 1 {
                    ListView(todoList: secondTodoList, segmentIndex: segmentIndex)
                }
                else if segmentIndex == 2 {
                    ListView(todoList: thirdTodoList, segmentIndex: segmentIndex)
                }
            }
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button {
                        isSheetShowing = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.principal) {
                    Text("왓투두")
                }
            }
        }
        .sheet(isPresented: $isSheetShowing) {
            settingView()
        }
    }

    @ViewBuilder func settingView() -> some View {
        Form {
            Section("이름 바꾸기") {

                TextField(firstSegment, text: $firstSegment)
                    .foregroundColor(Color.gray)
                    .textFieldStyle(.plain)
                    .padding()


                TextField(secondSegment, text: $secondSegment)
                    .foregroundColor(Color.gray)
                    .textFieldStyle(.plain)
                    .padding()


                TextField(thirdSegment, text: $thirdSegment)
                    .foregroundColor(Color.gray)
                    .textFieldStyle(.plain)
                    .padding()
            }
        }
    }
}
