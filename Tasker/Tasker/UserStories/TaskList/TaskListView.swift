//
//  TaskListView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import MokayUI
import SwiftUI
import SwiftData
import MokayDI

struct TaskListView: View {
	
	@State private var offsetY: CGFloat = 0
	@State private var isExpanded: Bool = false
	
	@StateObject var viewModel: TaskListViewModel
	@Environment(Router.self) var router
	
	private let gridItems = [
		GridItem(.flexible(minimum: 100, maximum: 300), spacing: .x1),
		GridItem(.flexible(minimum: 100, maximum: 300), spacing: .x1)
	]
	
	private var progress: CGFloat {
		max(min(offsetY / 100, 1), 0)
	}
	
	var body: some View {
		VStack(spacing: .x2) {
			headerView
			scrollView
		}
		.overlay(overlayView)
		.scrollTargetBehavior(scrollBehavior)
		.animation(.smooth(duration: 0.3, extraBounce: 0), value: isExpanded)
		.onReceive(NotificationCenter.default.publisher(for: .searchViewDidClose)) { _ in
			isExpanded = false
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

// MARK: - Subviews
extension TaskListView {
	private var headerView: some View {
		HStack(spacing: .x2) {
			searchField
			settingsOrCancelButton
		}
		.padding(.horizontal, .x2)
		.frame(height: 56)
	}
	
	private var scrollView: some View {
		ZStack(alignment: .bottomTrailing) {
			ScrollView(.vertical) {
				contentView
					.offset(y: isExpanded ? -offsetY : 0)
					.onGeometryChange(for: CGFloat.self) {
						$0.frame(in: .scrollView(axis: .vertical)).minY
					} action: { offsetY = $0 }
			}
			
			addTaskButton
				.offset(x: -.x3)
		}
	}
	
	@ViewBuilder
	private var contentView: some View {
		switch viewModel.viewState {
		case .idle:
			Color.white.onAppear(perform: viewModel.onAppear)
		case .loading:
			ProgressView().progressViewStyle(.circular)
		case .loaded(let tasks):
			if tasks.isEmpty {
				emptyStateView
			} else {
				taskGrid(tasks)
			}
		case .error:
			errorView
		}
	}
	
	private func taskGrid(_ tasks: [TaskRowViewModel]) -> some View {
		LazyVGrid(columns: gridItems) {
			ForEach(tasks) { task in
				TaskRow(viewModel: task)
			}
		}
		.padding(.x2)
	}
	
	private var emptyStateView: some View {
		VStack {
			Spacer()
			ErrorStateView(
				icon: Image(systemName: "list.bullet.clipboard"),
				title: "No tasks",
				subtitle: nil,
				button: {
					Button("Add task", action: onAddTaskTapped)
						.buttonStyle(.primaryMedium)
				}
			)
			Spacer()
		}
	}
	
	private var errorView: some View {
		ContentUnavailableView {
			Label("Error while loading tasks", systemImage: "network.slash")
		} actions: {
			Button("Reload", action: viewModel.reload)
				.buttonStyle(.primaryMedium)
		}
	}
	
	private var searchField: some View {
		HStack(spacing: .x1) {
			Image(.search)
				.resizable()
				.frame(width: 24, height: 24)
			
			TextField("", text: .constant(""), prompt: placeholderText)
				.typography(.body)
				.foregroundColor(Color.accent.primary)
				.allowsHitTesting(false)
		}
		.padding(.x2)
		.background {
			RoundedRectangle(cornerRadius: 24)
				.foregroundStyle(Color.accent.bgSecondary)
		}
		.contentShape(Rectangle())
		.onTapGesture {
			isExpanded = true
		}
	}
	
	private var settingsOrCancelButton: some View {
		Button(action: onSettingsTapped) {
			Image("control")
		}
		.buttonStyle(.secondarySmall)
		.opacity(isExpanded ? 0 : 1)
		.overlay(alignment: .trailing) {
			cancelButton
				.opacity(isExpanded ? 1 : 0)
				.fixedSize()
		}
		.padding(.leading, isExpanded ? .x3 : .zero)
	}
	
	private var cancelButton: some View {
		Button {
			isExpanded = false
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
	
	private var placeholderText: Text {
		Text("Search")
			.foregroundStyle(.gray)
	}
	
	private var addTaskButton: some View {
		Button(action: onAddTaskTapped) {
			Image("add")
				.renderingMode(.template)
				.foregroundStyle(Color.white)
		}
		.padding(24)
		.background(in: RoundedRectangle(cornerRadius: 24))
		.backgroundStyle(Color.accent.textPrimaryGreen)
	}

	
	private var overlayView: some View {
		Rectangle()
			.fill(.ultraThinMaterial)
			.background(Color.white.opacity(0.25))
			.ignoresSafeArea()
			.overlay {
				Container.main.resolve(SearchView.self)
			}
			.opacity(isExpanded ? 1 : progress)
	}
	
	private var scrollBehavior: OnScrollEnd {
		OnScrollEnd { dy in
			DispatchQueue.main.async {
				if offsetY > 100 || (dy > 1.5 && offsetY > 0) {
					isExpanded = true
				}
			}
		}
	}
}

// MARK: - Actions
extension TaskListView {
	private func onSettingsTapped() {
		router.push(.settings)
	}
	
	private func onAddTaskTapped() {
		router.present(.newTask)
	}
}
