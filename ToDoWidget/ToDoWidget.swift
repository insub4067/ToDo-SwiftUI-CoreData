//
//  ToDoWidget.swift
//  ToDoWidget
//
//  Created by Kim Insub on 2022/08/02.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ToDoWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(sortDescriptors: [SortDescriptor(\.isDone, order: .reverse)]) var todos: FetchedResults<TodoEntity>

//    let coreDataManager = CoreDataManager.shared

    var body: some View {

        let taskList = todos.filter { todo in
            todo.isDone == false
        }

        ForEach(taskList) { todo in
            Text(todo.task ?? "Hello")
        }
    }
}

@main
struct ToDoWidget: Widget {
    let kind: String = "ToDoWidget"
    @StateObject private var coreDataManager = CoreDataManager.shared

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ToDoWidgetEntryView(entry: entry)
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
