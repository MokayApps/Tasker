//
//  TaskListSection.swift
//  Tasker
//
//  Created by Andrei Kozlov on 17.08.2025.
//

import Foundation

struct TaskListSection: Identifiable {
	
	let id: UUID = UUID()
	let title: String
	let rows: [TaskRowViewModel]
}
