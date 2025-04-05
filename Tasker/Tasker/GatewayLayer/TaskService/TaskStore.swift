//
//  TaskStore.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

import SwiftData

protocol TaskStoreProtocol: Actor {
	
	func addTask(_ task: TaskItem) throws
	func fetchTasks() async throws -> [TaskItem]
	func deleteTask(_ task: TaskItem) throws
}

@ModelActor
actor TaskStore: TaskStoreProtocol {
	
	init(modelContainer: ModelContainer, modelExecutor: ModelExecutor) {
		self.modelExecutor = modelExecutor
		self.modelContainer = modelContainer
	}
	
	func addTask(_ task: TaskItem) throws {
		let taskModel = TaskModel(
			id: task.id,
			name: task.name,
			category: task.category,
			status: task.status,
			createdAt: task.createdAt,
			dueDate: task.dueDate
		)
		modelContext.insert(taskModel)
		try modelContext.save()
	}
	
	func fetchTasks() throws -> [TaskItem] {
		let fetchDescriptor = FetchDescriptor<TaskModel>()
		let tasks = try modelContext.fetch(fetchDescriptor)
		return tasks.map {
			TaskItem(
				id: $0.id,
				name: $0.name,
				category: $0.category,
				status: $0.status,
				createdAt: $0.createdAt,
				dueDate: $0.dueDate
			)
		}
	}
	
	func deleteTask(_ task: TaskItem) throws {
		let taskModel = TaskModel(
			id: task.id,
			name: task.name,
			category: task.category,
			status: task.status,
			createdAt: task.createdAt,
			dueDate: task.dueDate
		)
		modelContext.delete(taskModel)
		try modelContext.save()
	}
}
