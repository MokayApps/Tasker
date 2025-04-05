//
//  TaskServiceProtocol.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

public protocol TaskServiceProtocol: AnyObject, Sendable {
	
	func addTask(_ task: TaskItem) async throws
	func fetchTasks() async throws -> [TaskItem]
	func deleteTask(_ task: TaskItem) async throws
}
