//
//  MainView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import SwiftUI
import SwiftData
import MokayDI

struct MainView: View {
    
    @State var taskListRouter: Router = Router(container: Container.main)

    var body: some View {
        NavigationStack(path: $taskListRouter.path) {
            taskListRouter.view(for: .taskList)
                .navigationDestination(for: Route.self) { route in
                    taskListRouter.view(for: route)
                }
        }
        .environment(taskListRouter)
    }

}

#Preview {
    MainView()
        .modelContainer(for: Task.self, inMemory: true)
}
