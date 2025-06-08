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
    var presentedScreen: Screen?
    
    init(
        container: Container
    ) {
        self.container = container
    }
    
    @ViewBuilder func view(for screen: Screen) -> some View {
        switch screen {
        case .taskList:
            container.resolve(TaskListView.self)
        case .settings:
            container.resolve(SettingsView.self)
				case .newTask:
					container.resolve(NewTaskView.self)
        case .search:
					container.resolve(SearchView.self)
        case .categories:
            container.resolve(CategoriesView.self)
				}
    }
    
    @ViewBuilder func routerView(for screen: Screen) -> some View {
        switch screen {
        case .taskList:
            container.resolve(TaskListView.self)
        case .settings:
            container.resolve(SettingsView.self)
				case .newTask:
						RouterView<NewTaskView>(container: container, router: Router(container: container))
        case .search:
            RouterView<SearchView>(container: container, router: Router(container: container))
        case .categories:
            RouterView<CategoriesView>(container: container, router: Router(container: container))
        }
    }
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func present(_ screen: Screen) {
        presentedScreen = screen
    }
    
    func dismiss() {
        presentedScreen = nil
    }
}
