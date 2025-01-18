//
//  Item.swift
//  Tasker
//
//  Created by Andrei Kozlov on 4/1/25.
//

import Foundation
import SwiftData

@Model
final class Task {
    
    var id: UUID
    var name: String
    var category: String
    var status: String
    var createdAt: Date
    var dueDate: Date?
    
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
