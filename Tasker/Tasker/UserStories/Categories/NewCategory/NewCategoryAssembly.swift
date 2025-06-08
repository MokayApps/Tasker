import Foundation
import MokayDI

final class NewCategoryAssembly {
    func assemble(container: Container) {
        container.register(NewCategoryView.self) { resolver in
			MainActor.assumeIsolated {
				let taskService = resolver.resolve(TaskServiceProtocol.self)!
				return NewCategoryView(viewModel: NewCategoryViewModel(taskService: taskService))
			}
        }
    }
} 
