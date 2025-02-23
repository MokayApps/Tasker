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

@MainActor
@Observable
final class SearchViewModel {
	
	let categories: [TaskCategory]
	
	var filteredCategories: [TaskCategory] = []
	var selectedCategory: TaskCategory?
	
	var searchText: String = ""
	
	init() {
		categories = [
			TaskCategory(icon: "🏠", title: "Home", color: .red),
			TaskCategory(icon: "🏥", title: "Health", color: .yellow),
			TaskCategory(icon: "🛍️", title: "Shopping", color: .orange),
			TaskCategory(icon: "🗂️", title: "Work", color: .teal),
			TaskCategory(icon: "⚽️", title: "Sport", color: .pink),
		]
		
		filteredCategories = categories
	}
	
	var queryStringBinding: Binding<String> {
		return Binding<String> {
			return self.searchText
		} set: { newValue in
			self.searchText = newValue
			self.filteredCategories = self.filteredCategories(queryString: newValue)
		}
	}
	
	func filteredCategories(queryString: String) -> [TaskCategory] {
		return queryString.isEmpty ? categories : categories.filter { category in
			category.title.localizedCaseInsensitiveContains(queryString)
		}
	}
}
