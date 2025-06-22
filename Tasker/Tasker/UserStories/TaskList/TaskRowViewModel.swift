//
//  TaskRowViewModel.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import Foundation
import SwiftUI

@MainActor
final class TaskRowViewModel: ObservableObject, Identifiable {
    
    let id: UUID
    let title: String
    let category: String
    let status: String
    let createdAt: Date
    let dueDate: Date?
    
    @Published var isCompleted: Bool
    
    private let taskService: TaskServiceProtocol
    
    init(id: UUID, title: String, isCompleted: Bool, category: String = "", status: String = "", createdAt: Date = Date(), dueDate: Date? = nil, taskService: TaskServiceProtocol) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.category = category
        self.status = status
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.taskService = taskService
    }
    
    func toggleCompletion() {
        isCompleted.toggle()
        
        Task {
            let newStatus = isCompleted ? "completed" : "pending"
            let updatedTask = TaskItem(
                id: id,
                name: title,
                category: category,
                status: newStatus,
                createdAt: createdAt,
                dueDate: dueDate
            )
            
            do {
                try await taskService.updateTask(updatedTask)
            } catch {
                print("Error updating task: \(error)")
                // В случае ошибки откатываем изменение
                await MainActor.run {
                    isCompleted.toggle()
                }
            }
        }
    }
}
