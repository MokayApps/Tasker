//
//  TaskerApp.swift
//  Tasker
//
//  Created by Andrei Kozlov on 4/1/25.
//

import SwiftUI
import SwiftData
import MokayDI

@main
struct TaskerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Task.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        AppAssembly().assemble(container: Container.main)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .foregroundStyle(
                    .black,
                    .black.opacity(0.8),
                    .black.opacity(0.5)
                )
        }
        .modelContainer(sharedModelContainer)
    }
}
