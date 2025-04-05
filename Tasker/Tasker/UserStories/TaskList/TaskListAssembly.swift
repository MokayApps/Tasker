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
				let viewModel = TaskListViewModel(taskService: taskService)
				return TaskListView(viewModel: viewModel)
			}
		}
	}
}
