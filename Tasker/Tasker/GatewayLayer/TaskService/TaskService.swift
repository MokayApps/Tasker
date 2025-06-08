//
//  TaskService.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

import Foundation
import MokayDB
import SwiftData
@preconcurrency import Combine

final class TaskService: TaskServiceProtocol {
	
	private let store: TaskStoreProtocol
	
	init(store: TaskStoreProtocol) {
		self.store = store
	}
	
	func taskUpdatesStream() async -> NotificationCenter.Notifications {
		return await store.taskUpdatesStream()
	}
	
	func addTask(_ task: TaskItem) async throws {
		try await store.addTask(task)
	}
	
	func fetchTasks() async throws -> [TaskItem] {
		return try await store.fetchTasks()
	}
	
	func deleteTask(_ task: TaskItem) async throws {
		try await store.deleteTask(task)
	}
	
}

