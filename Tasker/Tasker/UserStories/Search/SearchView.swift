//
//  SearchView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import SwiftUI
import MokayUI

struct SearchView: View {
	
	@Environment(Router.self) var router
	@Environment(\.dismiss) private var dismiss
	
	@StateObject var viewModel: SearchViewModel
	
	@FocusState private var isSearchFieldFocused: Bool
	
	var body: some View {
		VStack(spacing: .x1) {
			headerView
			
			switch viewModel.viewState {
			case .empty:
				emptyView
			case let .result(sections):
				resultView(sections: sections)
			case .error:
				emptyResultView
			}
		}
		.onAppear {
			isSearchFieldFocused = true
		}
	}
}

extension SearchView {
	private var headerView: some View {
		VStack(spacing: .x1) {
			searchView
			categoriesView
		}
	}
	
	private var emptyView: some View {
		VStack {
			Spacer()
			VStack(spacing: .x1) {
				Spacer()
				Image(systemName: "magnifyingglass.circle.fill")
					.typography(.h1)
				
				Text("You can enter a categories, date or task name")
					.typography(.subhead)
				Spacer()
			}
			.foregroundStyle(Color.accent.secondaryTransparent)
			Spacer()
		}
	}
	
	private var emptyResultView: some View {
		VStack {
			Spacer()
			ErrorStateView(
				icon: Image(systemName: "exclamationmark.circle.fill"),
				title: "No tasks found. Create a new one?",
				button: {
					Button {
						router.present(.newTask)
					} label: {
						HStack(spacing: .x1) {
							Image(systemName: "plus.circle.fill")
								.typography(.sfSymbolL)
							
							Text("New task")
						}
					}
					.buttonStyle(.secondarySmall)
				}
			)
			Spacer()
		}
	}
	
	private func resultView(sections: [SearchSection]) -> some View {
		ScrollView(.vertical, showsIndicators: false) {
			LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: [.sectionHeaders]) {
				ForEach(sections) { section in
					sectionView(section)
				}
			}
		}
	}
}

extension SearchView {
	private var searchView: some View {
		HStack(spacing: .x2) {
			textField
			cancelButton
		}
		.padding(.horizontal, .x2)
	}
	
	private var categoriesView: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: .x1) {
				ForEach(viewModel.categories) { category in
					categoryItemView(category)
				}
			}
			.padding(.horizontal, .x2)
		}
	}
	
	private func sectionView(_ section: SearchSection) -> some View {
		Section {
			ForEach(section.items, id: \.self) { token in
				taskView
			}
		} header: {
			HeaderView(text: section.title, color: Color.accent.secondaryTransparent, style: .h2)
				.background {
					Color.white
				}
		}
	}
	
	private var taskView: some View {
		RoundedRectangle(cornerRadius: 15)
			.fill(.yellow)
			.frame(width: 200, height: 150)
	}
	
	private var textField: some View {
		HStack(spacing: .x1) {
			Image(.search)
				.resizable()
				.frame(width: 24, height: 24)
			
			TextField("", text: viewModel.queryStringBinding, prompt: placeholderText, axis: .horizontal)
				.focused($isSearchFieldFocused)
				.typography(.body)
				.foregroundColor(Color.accent.primary)
				.autocorrectionDisabled()
		}
		.padding(.x2)
		.frame(height: 56)
		.background {
			RoundedRectangle(cornerRadius: 24)
				.foregroundStyle(Color.accent.bgSecondary)
		}
	}
	
	private var placeholderText: Text {
		Text("Search")
			.foregroundStyle(.gray)
	}
	
	private var cancelButton: some View {
		Button {
			if viewModel.searchText.isEmpty {
				dismiss()
			} else {
				viewModel.queryStringBinding.wrappedValue = ""
			}
		} label: {
			Text("CANCEL")
				.typography(.smallLabel)
				.padding(.x1)
				.frame(height: 40)
				.background {
					RoundedRectangle(cornerRadius: 17)
						.foregroundStyle(Color.accent.bgSecondary)
				}
		}
	}
	
	private func categoryItemView(_ category: TaskCategory) -> some View {
		let isSelected = category.id == viewModel.selectedCategory?.id
		return Button {
			withAnimation(.easeInOut(duration: 0.25)) {
				viewModel.selectedCategory = category
			}
		} label: {
			HStack(spacing: .x1) {
				Text(category.icon)
				Text(category.title)
					.typography(.smallLabel)
				
				Button {
					withAnimation(.easeInOut(duration: 0.25)) {
						viewModel.selectedCategory = nil
					}
				} label: {
					Image(systemName: "xmark")
						.typography(.subhead)
						.foregroundStyle(Color.accent.textSecondary)
				}
				.scaleEffect(isSelected ? 1 : 0.5)
				.opacity(isSelected ? 1 : 0)
				.frame(width: isSelected ? nil : 0)
				.animation(.easeInOut(duration: 0.25), value: isSelected)
			}
		}
		.buttonStyle(.secondarySmall)
		.backgroundStyle(category.id == viewModel.selectedCategory?.id ? category.color.opacity(0.5) : Color.accent.bgSecondary)
	}
}
