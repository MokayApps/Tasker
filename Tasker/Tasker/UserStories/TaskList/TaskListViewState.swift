//
//  TaskListViewState.swift
//  Tasker
//
//  Created by Andrei Kozlov on 05.04.2025.
//

enum TaskListViewState {
	case idle
	case loading
	case loaded([TaskRowViewModel])
	case error
}
