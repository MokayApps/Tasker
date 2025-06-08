//
//  NewCategoryViewModel.swift
//  Tasker
//
//  Created by Roman Apanasevich on 13.04.2025.
//

import SwiftUI

@MainActor
final class NewCategoryViewModel: ObservableObject {
	@Published var trackerCategory: String = ""
	@Published var emoji: String = ""
	@Published var selectedColor: Color?
	@Published var isPresentedEmoji: Bool = false
	
	private let taskService: TaskServiceProtocol
	
	init(taskService: TaskServiceProtocol) {
		self.taskService = taskService
	}
	
	func addCategory() {
		Task {
			let category = TaskCategory(
				id: UUID(),
				name: trackerCategory,
				icon: emoji,
				color: selectedColor?.toHex() ?? "#000000",
				createdAt: Date()
			)
			do {
				try await taskService.addCategory(category)
			} catch {
				print(error)
			}
		}
	}
}
