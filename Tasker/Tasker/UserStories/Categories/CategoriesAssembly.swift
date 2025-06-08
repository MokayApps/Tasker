import MokayDI

struct CategoriesAssembly {
    func assemble(container: Container) {
        container.register(CategoriesView.self) { resolver in
            MainActor.assumeIsolated {
                let taskService = resolver.resolve(TaskServiceProtocol.self)!
                return CategoriesView(
                    viewModel: CategoriesViewModel(
                        taskService: taskService
                    )
                )
            }
        }
    }
} 