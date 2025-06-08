//
//  DatabaseSchemaV1_0_0.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

import SwiftData

enum DatabaseSchemaV1_0_0: VersionedSchema {
	static var versionIdentifier: Schema.Version {
		Schema.Version(1, 0, 0)
	}
	
	static var models: [any PersistentModel.Type] {
		[TaskModel.self, TaskCategoryModel.self]
	}
}
