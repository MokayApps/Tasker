//
//  TaskServiceProtocol.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

import Combine
import Foundation

public protocol TaskServiceProtocol: AnyObject, Sendable {
	
	func taskUpdatesStream() async -> NotificationCenter.Notifications
	func addTask(_ task: TaskItem) async throws
	func fetchTasks() async throws -> [TaskItem]
	func deleteTask(_ task: TaskItem) async throws
}
