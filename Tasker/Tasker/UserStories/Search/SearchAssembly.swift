//
//  SearchAssembly.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import MokayDI

struct SearchAssembly {
	
	func assemble(container: Container) {
		container.register(SearchView.self) { resolver in
			MainActor.assumeIsolated {
                SearchView()
			}
		}
	}
}
