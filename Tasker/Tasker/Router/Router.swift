//
//  Router.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import SwiftUI
import MokayDI

@MainActor
@Observable
final class Router: Sendable {

    let container: Container
    var path: NavigationPath = NavigationPath()
    
    init(
        container: Container
    ) {
        self.container = container
    }
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .taskList:
            container.resolve(TaskListView.self)
        case .settings:
            container.resolve(SettingsView.self)
        case .search:
            container.resolve(SearchView.self)
        }
    }
    
    func push(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
