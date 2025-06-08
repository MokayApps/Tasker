//
//  SettingsAssembly.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import MokayDI

struct SettingsAssembly {
	
	func assemble(container: Container) {
		container.register(SettingsView.self) { resolver in
			MainActor.assumeIsolated {
				SettingsView(viewModel: SettingsViewModel())
			}
		}
	}
}
