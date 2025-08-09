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
	
	func onAppear() {
		
	}
	
	func keyboardDidDismiss() {
		bottomViewModel.viewState = .initial
	}
	
	private func subscribeOnBottomViewModel() {
		bottomViewModel.$viewState
			.filter { $0 != .initial }
			.sink { [weak self] _ in
				guard let self else { return }
				
			}
	}
}
