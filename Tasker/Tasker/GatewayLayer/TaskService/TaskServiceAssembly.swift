//
//  TaskServiceAssembly.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

import MokayDI
import SwiftData

struct TaskServiceAssembly {
	
	func assemble(container: Container) {
		container.register(TaskServiceProtocol.self) { resolver in
			let store = resolver.resolve(TaskStoreProtocol.self)!
			return TaskService(store: store)
		}
		container.register(TaskStoreProtocol.self, in: .container) { resolver in
			TaskStore(modelContainer: resolver.resolve(ModelContainer.self)!)
		}
	}
}
