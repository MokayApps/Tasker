//
//  SearchViewModel.swift
//  Tasker
//
//  Created by Єгор Привалов on 29.01.2025.
//

import Foundation
import SwiftUI

struct TaskCategory: Hashable, Identifiable {
	let id: String = UUID().uuidString
	var icon: String
	var title: String
	var color: Color = .blue
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
	
	private let allTasks: [String]
	let categories: [TaskCategory]
	
	@Published var selectedCategory: TaskCategory?
	@Published var viewState: ViewState = .empty
	
	init() {
		categories = [
			TaskCategory(icon: "🏠", title: "Home", color: .red),
			TaskCategory(icon: "🏥", title: "Health", color: .yellow),
			TaskCategory(icon: "🛍️", title: "Shopping", color: .orange),
			TaskCategory(icon: "🗂️", title: "Work", color: .teal),
			TaskCategory(icon: "⚽️", title: "Sport", color: .pink),
		]
		
		allTasks = [
			"Buy groceries", "Workout", "Meeting with team", "Dentist appointment", "Call mom",
			"Finish project", "Read book", "Plan vacation", "Pay bills", "Learn Swift",
			"Write article", "Go to the gym", "Buy new laptop", "Cook dinner", "Walk the dog"
		]
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
		
		let filteredTasks = allTasks.filter { $0.localizedCaseInsensitiveContains(searchText) }
		
		viewState = filteredTasks.isEmpty
		? .error
		: .result(sections: filteredTasks.map { SearchSection(title: "Task: \($0)", items: [$0]) })
	}
}
