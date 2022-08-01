//
//  ToDo_SwiftUIApp.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/02.
//

import SwiftUI

@main
struct ToDo_SwiftUIApp: App {
    @StateObject private var coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
