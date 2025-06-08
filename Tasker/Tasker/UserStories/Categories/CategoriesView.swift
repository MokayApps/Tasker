import SwiftUI
import MokayUI

struct CategoriesView: View {
	@Environment(Router.self) private var router
    @StateObject var viewModel: CategoriesViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .idle:
                Color.white.onAppear(perform: viewModel.onAppear)
            case .loading:
                ProgressView().progressViewStyle(.circular)
            case .loaded(let categories) where categories.isEmpty:
                emptyStateView
            case .loaded(let categories):
                ScrollView {
                    LazyVStack(spacing: .x2) {
                        ForEach(categories) { category in
                            CategoryRow(viewModel: category)
                        }
                    }
                    .padding(.x2)
                }
            case .error:
                ContentUnavailableView {
                    Label("Error while loading categories", systemImage: "network.slash")
                } actions: {
                    Button("Reload", action: viewModel.reload)
                        .buttonStyle(.primaryMedium)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
					router.present(.newCategory)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            await viewModel.fetchCategories()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            ErrorStateView(
                icon: Image(systemName: "folder.badge.plus"),
                title: "No categories",
                subtitle: "Add your first category to organize tasks",
                button: {
                    Button("Add category") {
						router.present(.newCategory)
                    }
                    .buttonStyle(.primaryMedium)
                }
            )
            Spacer()
        }
    }
}

struct CategoryRow: View {
    let viewModel: CategoryRowViewModel
    
    var body: some View {
        HStack(spacing: .x2) {
            Image(systemName: viewModel.icon)
                .typography(.sfSymbolL)
                .foregroundStyle(viewModel.color)
            
            Text(viewModel.name)
                .typography(.mediumLabel)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.x2)
        .background {
            RoundedRectangle(cornerRadius: 17)
                .fill(viewModel.color.opacity(0.1))
        }
    }
} 
