import Foundation
import SwiftData

@Model
public final class TaskCategoryModel {
    @Attribute(.unique)
    public var id: UUID
    public var name: String
    public var icon: String
    public var color: String
    public var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        color: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.createdAt = createdAt
    }
} 