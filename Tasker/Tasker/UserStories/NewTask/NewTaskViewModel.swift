//
//  NewTaskViewModel.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class NewTaskViewModel: ObservableObject {
	@Published var taskName: String = ""
	@Published var selectedDate: Date = .now
	@Published var isKeyboardShown: Bool = true

	let bottomViewModel = NewTaskBottomViewModel()
	
	private let taskService: TaskServiceProtocol
	
	private var subscriptions: Set<AnyCancellable> = []
	
	init(taskService: TaskServiceProtocol) {
		self.taskService = taskService
		bottomViewModel.onAddTaskCompletion = { [weak self] in
			guard let self else { return }
			addTask()
		}
		subscribeOnBottomViewModel()
	}
	
	func addTask() {
		Task {
			let task = TaskItem(
				id: UUID(),
				name: taskName,
				category: "Mock task",
				status: "Mock task",
				createdAt: Date(),
				dueDate: bottomViewModel.selectedDate
			)
			do {
				try await taskService.addTask(task)
			} catch {
				print(error)
			}
		}
	}
	
	func onAppear() {
		
	}
	
	func keyboardDidDismiss() {
		bottomViewModel.viewState = .initial
	}
	
	private func subscribeOnBottomViewModel() {
		bottomViewModel.$viewState
			.removeDuplicates()
			.filter { $0 != .initial }
			.sink { [weak self] _ in
				guard let self else { return }
				isKeyboardShown = false
			}
			.store(in: &subscriptions)
		
		$isKeyboardShown
			.removeDuplicates()
			.filter { $0 }
			.sink { [bottomViewModel] shown in
				bottomViewModel.viewState = .initial
			}
			.store(in: &subscriptions)
	}
}
