//
//  Route.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

enum Screen: Int, Hashable, Identifiable {
    
    var id: Int { rawValue }
    
    case taskList
    case settings
	case newTask
    case search
    case categories
	case newCategory
}
