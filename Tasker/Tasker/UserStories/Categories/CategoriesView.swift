import SwiftUI
import MokayUI

struct CategoriesView: View {
    @StateObject var viewModel: CategoriesViewModel
    @Environment(\.dismiss) private var dismiss
    
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
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onAddTapped) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.secondarySmall)
            }
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
                        onAddTapped()
                    }
                    .buttonStyle(.primaryMedium)
                }
            )
            Spacer()
        }
    }
    
    private func onAddTapped() {
        // TODO: Show add category sheet
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