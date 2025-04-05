//
//  Task.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

import Foundation

public struct TaskItem: Sendable {
	let id: UUID
	let name: String
	let category: String
	let status: String
	let createdAt: Date
	let dueDate: Date?
}
