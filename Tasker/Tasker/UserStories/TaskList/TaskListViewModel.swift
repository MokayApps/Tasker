//
//  TaskListViewModel.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import SwiftUI
import Combine

@MainActor
final class TaskListViewModel: ObservableObject {
    
	@Published var viewState: TaskListViewState = .idle
	
	private let taskService: TaskServiceProtocol
	
	private var subscriptions: Set<AnyCancellable> = []
	
	init(taskService: TaskServiceProtocol) {
		self.taskService = taskService
	}
	
	func onAppear() {
		Task {
			await fetchTasks()
			subscribeOnTaskChanges()
		}
	}
	
	func subscribeOnTaskChanges() {
		Task {
			for await _ in await taskService.taskUpdatesStream() {
				await checkForTaskCountChanges()
			}
		}
	}
	
	private func checkForTaskCountChanges() async {
		guard case .loaded(let currentTasks) = viewState else {
			await fetchTasks()
			return
		}
		
		do {
			let tasks = try await taskService.fetchTasks()
			
			if tasks.count != currentTasks.count {
				await fetchTasks()
			}
		} catch {
			print("Error checking task count: \(error)")
		}
	}
	
	func reload() {
		Task {
			await fetchTasks()
		}
	}
	
	func addTask() {
		Task {
			let task = TaskItem(
				id: UUID(),
				name: "Mock task",
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
	
	private func fetchTasks() async {
		viewState = .loading
		do {
			let tasks = try await taskService.fetchTasks()
			let viewModels: [TaskRowViewModel] = tasks.map {
				TaskRowViewModel(
					id: $0.id,
					title: $0.name,
					isCompleted: $0.status == "completed",
					category: $0.category,
					status: $0.status,
					createdAt: $0.createdAt,
					dueDate: $0.dueDate,
					taskService: taskService
				)
			}
			viewState = .loaded(viewModels)
		} catch {
			viewState = .error
		}
	}
}
