//
//  TodoListAssembly.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import MokayDI

struct TaskListAssembly {
	
	func assemble(container: Container) {
		container.register(TaskListView.self) { resolver in
			MainActor.assumeIsolated {
				let taskService = resolver.resolve(TaskServiceProtocol.self)!
				return TaskListView(
					viewModel: TaskListViewModel(
						taskService: taskService
					)
				)
			}
		}
	}
}
