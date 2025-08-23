//
//  NewTaskCategoryItem.swift
//  Tasker
//
//  Created by Andrei Kozlov on 17.08.2025.
//

import Foundation

struct NewTaskCategoryItem: Identifiable, Hashable {
	let id: UUID
	let name: String
	let icon: String
	
	init(id: UUID = UUID(), name: String, icon: String) {
		self.id = id
		self.name = name
		self.icon = icon
	}
}
