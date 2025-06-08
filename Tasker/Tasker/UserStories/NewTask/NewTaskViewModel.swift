//
//  NewTaskViewModel.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import Foundation
import SwiftUI

@MainActor
final class NewTaskViewModel: ObservableObject {
	var taskName: String = ""
	var selectedDate: Date = .now
	
	@ObservationIgnored
	private let taskService: TaskServiceProtocol
	
	init(taskService: TaskServiceProtocol) {
		self.taskService = taskService
	}
	
	var taskNameBinding: Binding<String> {
		Binding(
			get: { self.taskName },
			set: { self.taskName = $0 }
		)
	}
	
	var selectedDateBinding: Binding<Date> {
		Binding(
			get: { self.selectedDate },
			set: { self.selectedDate = $0 }
		)
	}
	
	func addTask() {
		Task {
			let task = TaskItem(
				id: UUID(),
				name: taskName,
				category: "Mock task",
				status: "Mock task",
				createdAt: Date(),
				dueDate: Date()
			)
			do {
				try await taskService.addTask(task)
			} catch {
				print(error)
			}
		}
	}
}
