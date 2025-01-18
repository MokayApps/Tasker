//
//  TaskListViewModel.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import SwiftUI

@MainActor
@Observable
final class TaskListViewModel {
    
    var tasks: [TaskRowViewModel] = []
    
    init() {
        tasks = [
            TaskRowViewModel(id: UUID(), title: "Task 1", isCompleted: false),
            TaskRowViewModel(id: UUID(), title: "Task 2", isCompleted: true),
            TaskRowViewModel(id: UUID(), title: "Task 3", isCompleted: false)
        ]
    }
}
