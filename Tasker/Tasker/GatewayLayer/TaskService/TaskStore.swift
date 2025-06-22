//
//  TaskStore.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

import Foundation
import SwiftData

enum TaskStoreError: Error {
	case taskNotFound
}

protocol TaskStoreProtocol: Actor {
	
	func taskUpdatesStream() -> NotificationCenter.Notifications
	func addTask(_ task: TaskItem) throws
	func fetchTasks() async throws -> [TaskItem]
	func updateTask(_ task: TaskItem) throws
	func deleteTask(_ task: TaskItem) throws
	
	// Category methods
	func addCategory(_ category: TaskCategory) throws
	func fetchCategories() async throws -> [TaskCategory]
	func deleteCategory(_ category: TaskCategory) throws
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
	
	func updateTask(_ task: TaskItem) throws {
		let taskId = task.id
		let fetchDescriptor = FetchDescriptor<TaskModel>(
			predicate: #Predicate<TaskModel> { $0.id == taskId }
		)
		let existingTasks = try modelContext.fetch(fetchDescriptor)
		
		guard let existingTask = existingTasks.first else {
			throw TaskStoreError.taskNotFound
		}
		
		existingTask.name = task.name
		existingTask.category = task.category
		existingTask.status = task.status
		existingTask.dueDate = task.dueDate
		
		try modelContext.save()
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
	
	func taskUpdatesStream() -> NotificationCenter.Notifications {
		return NotificationCenter.default.notifications(
			named: ModelContext.didSave,
			object: nil
		)
	}
	
	// Category methods
	func addCategory(_ category: TaskCategory) throws {
		let categoryModel = TaskCategoryModel(
			id: category.id,
			name: category.name,
			icon: category.icon,
			color: category.color,
			createdAt: category.createdAt
		)
		modelContext.insert(categoryModel)
		try modelContext.save()
	}
	
	func fetchCategories() throws -> [TaskCategory] {
		let fetchDescriptor = FetchDescriptor<TaskCategoryModel>()
		let categories = try modelContext.fetch(fetchDescriptor)
		return categories.map {
			TaskCategory(
				id: $0.id,
				name: $0.name,
				icon: $0.icon,
				color: $0.color,
				createdAt: $0.createdAt
			)
		}
	}
	
	func deleteCategory(_ category: TaskCategory) throws {
		let categoryModel = TaskCategoryModel(
			id: category.id,
			name: category.name,
			icon: category.icon,
			color: category.color,
			createdAt: category.createdAt
		)
		modelContext.delete(categoryModel)
		try modelContext.save()
	}
}
