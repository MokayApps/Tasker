import Foundation
import SwiftUI

enum CategoriesViewState {
    case idle
    case loading
    case loaded([CategoryRowViewModel])
    case error
}

struct CategoryRowViewModel: Identifiable {
    let id: UUID
    let name: String
    let icon: String
    let color: Color
}

@MainActor
final class CategoriesViewModel: ObservableObject {
    @Published var viewState: CategoriesViewState = .idle
    
    private let taskService: TaskServiceProtocol
    
    init(taskService: TaskServiceProtocol) {
        self.taskService = taskService
    }
    
    func onAppear() {
        Task {
            await fetchCategories()
            subscribeOnCategoryChanges()
        }
    }
    
    func reload() {
        Task {
            await fetchCategories()
        }
    }
    
    func subscribeOnCategoryChanges() {
        Task {
			for await _ in await taskService.taskUpdatesStream() {
                await fetchCategories()
            }
        }
    }
    
    func addCategory(name: String, icon: String, color: Color) {
        Task {
            let category = TaskCategory(
                id: UUID(),
                name: name,
                icon: icon,
                color: color.toHex() ?? "#000000",
                createdAt: Date()
            )
            do {
                try await taskService.addCategory(category)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchCategories() async {
        viewState = .loading
        do {
            let categories = try await taskService.fetchCategories()
            let viewModels: [CategoryRowViewModel] = categories.map {
                CategoryRowViewModel(
                    id: $0.id,
                    name: $0.name,
                    icon: $0.icon,
                    color: Color(hex: $0.color) ?? .blue
                )
            }
            viewState = .loaded(viewModels)
        } catch {
            viewState = .error
        }
    }
} 
