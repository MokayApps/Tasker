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
				await fetchTasks()
			}
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
				TaskRowViewModel(id: $0.id, title: $0.name, isCompleted: $0.status == "completed")
			}
			viewState = .loaded(viewModels)
		} catch {
			viewState = .error
		}
	}
}
