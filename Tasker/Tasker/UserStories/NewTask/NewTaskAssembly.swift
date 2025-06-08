//
//  NewTaskAssembly.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import MokayDI

struct NewTaskAssembly {
	
	func assemble(container: Container) {
		container.register(NewTaskView.self) { resolver in
			MainActor.assumeIsolated {
				let taskService = resolver.resolve(TaskServiceProtocol.self)!
				return NewTaskView(
					viewModel: NewTaskViewModel(
						taskService: taskService
					)
				)
			}
		}
	}
}
