import Foundation
import SwiftUI

public struct TaskCategory: Sendable {
    let id: UUID
    let name: String
    let icon: String
    let color: String
    let createdAt: Date
} 