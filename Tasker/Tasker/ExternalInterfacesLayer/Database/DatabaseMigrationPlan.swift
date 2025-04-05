//
//  DatabaseMigrationPlan.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

import SwiftData

public enum DatabaseMigrationPlan: SchemaMigrationPlan {
	
	public static var schemas: [any VersionedSchema.Type] {
		[DatabaseSchemaV1_0_0.self]
//		 DatabaseSchemaV2_0_0.self]
	}
	
	public static var stages: [MigrationStage] {
//		[migrateV1toV2]
		[]
	}
	
//	static var migrateV1toV2: MigrationStage {
//		.custom(
//			fromVersion: DatabaseSchemaV1_0_0.self,
//			toVersion: DatabaseSchemaV2_0_0.self,
//			willMigrate: { context in
//				let users = try context.fetch(FetchDescriptor<ItemsSchemaV1.User>())
//				var usedNames = Set<String>()
//				for user in users {
//					if usedNames.contains(user.name) {
//						context.delete(user)
//					}
//					usedNames.insert(user.name)
//				}
//				try context.save()
//			},
//			didMigrate: nil
//		)
//	}
	
}
