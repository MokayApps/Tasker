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
    }
}
