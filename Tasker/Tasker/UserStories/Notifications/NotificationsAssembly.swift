//
//  NotificationsAssembly.swift
//  Tasker
//
//  Created by Andrei Kozlov on 02/02/25.
//

import MokayDI

struct NotificationsAssembly {
	
	func assemble(container: Container) {
		container.register(NotificationsView.self) { resolver in
			MainActor.assumeIsolated {
				NotificationsView(viewModel: NotificationsViewModel())
			}
		}
	}
}
