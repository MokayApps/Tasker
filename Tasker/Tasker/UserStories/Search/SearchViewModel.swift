//
//  SearchViewModel.swift
//  Tasker
//
//  Created by Єгор Привалов on 29.01.2025.
//

import Foundation
import SwiftUI

struct SearchTaskCategoryViewModel: Hashable, Identifiable {
	let id: UUID
	var icon: String
	var title: String
	var color: Color
}

struct SearchSection: Identifiable {
	let id: String = UUID().uuidString
	let title: String
	let items: [String]
}

@MainActor
final class SearchViewModel: ObservableObject {
	
	enum ViewState {
		case empty
		case result(sections: [SearchSection])
		case error
	}
	
	var searchText: String = "" {
		didSet { updateViewState() }
	}
	
	private let taskService: TaskServiceProtocol
	@Published var selectedCategory: SearchTaskCategoryViewModel?
	@Published var viewState: ViewState = .empty
	@Published var categories: [SearchTaskCategoryViewModel] = []
	
	init(taskService: TaskServiceProtocol) {
		self.taskService = taskService
	}
	
	func onAppear() {
		Task {
			await fetchCategories()
			subscribeOnCategoryChanges()
		}
	}
	
	func subscribeOnCategoryChanges() {
		Task {
			for await _ in await taskService.taskUpdatesStream() {
				await fetchCategories()
			}
		}
	}
	
	func fetchCategories() async {
		do {
			let dbCategories = try await taskService.fetchCategories()
			categories = dbCategories.map { category in
				SearchTaskCategoryViewModel(
					id: category.id,
					icon: category.icon,
					title: category.name,
					color: Color(hex: category.color) ?? .blue
				)
			}
		} catch {
			print(error)
		}
	}
	
	var queryStringBinding: Binding<String> {
		Binding(
			get: { self.searchText },
			set: { self.searchText = $0 }
		)
	}
	
	private func updateViewState() {
		guard !searchText.isEmpty else {
			viewState = .empty
			return
		}
		
		Task {
			do {
				let tasks = try await taskService.fetchTasks()
				let filteredTasks = tasks.filter { task in
					let matchesSearch = task.name.localizedCaseInsensitiveContains(searchText)
					let matchesCategory = selectedCategory == nil || task.category == selectedCategory?.title
					return matchesSearch && matchesCategory
				}
				
				if filteredTasks.isEmpty {
					viewState = .error
				} else {
					let sections = filteredTasks.map { task in
						SearchSection(title: "Task: \(task.name)", items: [task.name])
					}
					viewState = .result(sections: sections)
				}
			} catch {
				viewState = .error
			}
		}
	}
}
