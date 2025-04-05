//
//  Item.swift
//  Tasker
//
//  Created by Andrei Kozlov on 4/1/25.
//

import Foundation
import SwiftData

@Model
public final class TaskModel {
    
	@Attribute(.unique)
	public var id: UUID
	public var name: String
	public var category: String
	public var status: String
	public var createdAt: Date
	public var dueDate: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        status: String,
        createdAt: Date = Date(),
        dueDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.status = status
        self.createdAt = createdAt
        self.dueDate = dueDate
    }
}
