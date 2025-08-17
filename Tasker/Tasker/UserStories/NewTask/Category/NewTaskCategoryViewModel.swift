//
//  NewTaskCategoryViewModel.swift
//  Tasker
//
//  Created by Andrei Kozlov on 17.08.2025.
//

import Foundation

final class NewTaskCategoryViewModel: ObservableObject {
	
	@Published var selectedCategory: String = ""
	@Published var categories: [NewTaskCategoryItem] = []

	init() {
		self.categories = [
			NewTaskCategoryItem(name: "SHOPPING", icon: "🛍️"),
			NewTaskCategoryItem(name: "SHOPPING", icon: "🛍️"),
			NewTaskCategoryItem(name: "SHOPPING", icon: "🛍️"),
			NewTaskCategoryItem(name: "SHOPPING", icon: "🛍️")
		]
	}
	
}
