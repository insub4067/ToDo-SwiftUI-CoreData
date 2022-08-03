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
    @State private var currentSelectedIndex = 0

    @AppStorage("영역1") var firstSegment: String = "카테고리"
    @AppStorage("영역2") var secondSegment: String =  "카테고리"
    @AppStorage("영역3") var thirdSegment: String = "카테고리"

    @State var firstSegmentName: String = ""
    @State var secondSegmentName: String = ""
    @State var thirdSegmentName: String = ""

    let coreDataManager = CoreDataManager.shared

    var body: some View {

        NavigationView {
            VStack {
                Picker("영역 구분", selection: $currentSelectedIndex) {
                    Text(firstSegment).tag(0)
                    Text(secondSegment).tag(1)
                    Text(thirdSegment).tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if currentSelectedIndex == 0 {
                    ListView(todoList: firstTodoList, segmentIndex: currentSelectedIndex)
                }
                else if currentSelectedIndex == 1 {
                    ListView(todoList: secondTodoList, segmentIndex: currentSelectedIndex)
                }
                else if currentSelectedIndex == 2 {
                    ListView(todoList: thirdTodoList, segmentIndex: currentSelectedIndex)
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
        ZStack {
            Form {
                TextField(firstSegment, text: $firstSegmentName)
                    .foregroundColor(Color.gray)
                    .textFieldStyle(.plain)
                    .padding()

                TextField(secondSegment, text: $secondSegmentName)
                    .foregroundColor(Color.gray)
                    .textFieldStyle(.plain)
                    .padding()

                TextField(thirdSegment, text: $thirdSegmentName)
                    .foregroundColor(Color.gray)
                    .textFieldStyle(.plain)
                    .padding()
            }
            .padding(.top, 20)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        if firstSegmentName != "" {
                            firstSegment = firstSegmentName
                            firstSegmentName = ""
                        }

                        else if secondSegmentName != "" {
                            secondSegment = secondSegmentName
                            secondSegmentName = ""

                        }

                        else if thirdSegmentName != "" {
                            thirdSegment = thirdSegmentName
                            thirdSegmentName = ""
                        }
                    } label: {
                        Text("저장")
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}
