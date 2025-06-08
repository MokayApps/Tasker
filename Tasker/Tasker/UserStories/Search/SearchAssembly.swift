//
//  SearchAssembly.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import Foundation
import MokayDI

final class SearchAssembly {
	
	func assemble(container: Container) {
		container.register(SearchView.self) { resolver in
			MainActor.assumeIsolated {
				let taskService = resolver.resolve(TaskServiceProtocol.self)!
				return SearchView(viewModel: SearchViewModel(taskService: taskService))
			}
		}
	}
}
