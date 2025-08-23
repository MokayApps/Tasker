//
//  NewTaskRemindViewModel.swift
//  Tasker
//
//  Created by Andrei Kozlov on 17.08.2025.
//

import Foundation

struct NewTaskRemindItem: Identifiable {
	let id: UUID
	let title: String
}

final class NewTaskRemindViewModel: ObservableObject {
	
	@Published var selectedItem: NewTaskRemindItem?
	@Published var items: [NewTaskRemindItem] = []
	
	init() {
		items = [
			NewTaskRemindItem(id: UUID(), title: "1 HOUR"),
			NewTaskRemindItem(id: UUID(), title: "2 HOURS"),
			NewTaskRemindItem(id: UUID(), title: "3 HOURS"),
			NewTaskRemindItem(id: UUID(), title: "4 HOURS"),
			NewTaskRemindItem(id: UUID(), title: "5 HOURS"),
		]
				 
	}
}

