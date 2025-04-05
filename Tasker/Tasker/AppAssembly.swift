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
		SearchAssembly().assemble(container: container)
		TaskServiceAssembly().assemble(container: container)
		ModelContainerAssembly().assemble(container: container)
	}
}
