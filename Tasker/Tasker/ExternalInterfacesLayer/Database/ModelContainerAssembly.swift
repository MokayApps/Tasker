//
//  ModelContainerAssembly.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

import SwiftData
import MokayDI

struct ModelContainerAssembly {
	
	func assemble(container: Container) {
		container.register(ModelContainer.self, in: .container) { resolver in
			let schema = Schema(versionedSchema: DatabaseSchemaV1_0_0.self)
			let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
			let modelContainer = try! ModelContainer(
				for: schema,
				migrationPlan: DatabaseMigrationPlan.self,
				configurations: [configuration]
			)
			let modelContext = ModelContext(modelContainer)
			modelContext.autosaveEnabled = false
			return modelContainer
		}
	}
}
