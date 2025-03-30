//
//  NewCategoryAssembly.swift
//  Tasker
//
//  Created by Roman Apanasevich on 16.02.2025.
//

import MokayDI

struct NewCategoryAssembly {
	
	func assemble(container: Container) {
		container.register(NewCategoryView.self) { resolver in
			MainActor.assumeIsolated {
				NewCategoryView()
			}
		}
	}
}
