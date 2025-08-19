//
//  AppAssembly.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//


import MokayDI

struct AppAssembly {
	
	func assemble(container: Container) {
		TaskListAssembly().assemble(container: container)
		SettingsAssembly().assemble(container: container)
		NewTaskAssembly().assemble(container: container)
		SearchAssembly().assemble(container: container)
		CategoriesAssembly().assemble(container: container)
		TaskServiceAssembly().assemble(container: container)
		ModelContainerAssembly().assemble(container: container)
		NewCategoryAssembly().assemble(container: container)
		NotificationsAssembly().assemble(container: container)
	}
}
