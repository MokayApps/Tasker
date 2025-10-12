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
	
	@StateObject var viewModel: TaskListViewModel
	@Environment(Router.self) var router
	
	private let gridItems = [
		GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: .x1)
	]
	
	var body: some View {
		VStack(spacing: .x2) {
			headerView
			scrollView
		}
		.searchable(text: viewModel.searchTextBinding)
		.toolbar {
			// Top
			paywallToolbarItem
			settingsToolbarItem
			
			// Bottom
			DefaultToolbarItem(kind: .search, placement: .bottomBar)
			ToolbarSpacer(placement: .bottomBar)
			addTaskToolbarItem
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

// MARK: - Subviews
extension TaskListView {
	private var headerView: some View {
		HStack(spacing: .x2) {
			callendarView
		}
	}
	
	private var scrollView: some View {
		ScrollView(.vertical) {
			contentView
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
	
	private var callendarView: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 8) {
				HStack(spacing: 8) {
					ForEach(0..<7) { index in
						VStack(spacing: 4) {
							Text("5")
								.typography(.h4)
							Text("FRI")
								.typography(.caption)
						}
						.padding(.top, 8)
						.padding(.bottom, 12)
						.frame(width: 60, height: 60)
						.background {
							RoundedRectangle(cornerRadius: .r2)
								.foregroundStyle(Color.secondaryGray)
						}
						.overlay {
							RoundedRectangle(cornerRadius: .r2)
								.stroke(Color.accentGreen, lineWidth: 1)
						}
					}
				}
				
				ContentMenuView(label: {
					VStack(spacing: .zero) {
						Image(systemName: "calendar")
							.typography(.sfSymbolL)
						Text("DATE")
							.typography(.smallLabel)
					}
					.frame(width: 60, height: 60)
					.background {
						RoundedRectangle(cornerRadius: .r2)
							.foregroundStyle(Color.secondaryGray)
					}
				}, style: .plain) {
					DatePicker(
						"Select date",
						selection: $viewModel.selectedDate,
						displayedComponents: [.date]
					)
					.datePickerStyle(.graphical)
					.frame(width: 300, height: 300)
				}
			}
			.padding(.horizontal, .x2)
			.padding(.vertical, .x1)
		}
	}
	
	private func taskGrid(_ sections: [TaskListSection]) -> some View {
		LazyVGrid(columns: gridItems) {
			ForEach(sections) { section in
				Section {
					ForEach(section.rows) { task in
						TaskRow(viewModel: task)
							.contextMenu {
								contextMenu(for: task)
							}
							.padding(.horizontal, .x2)
					}
				} footer: {
					EmptyView()
				}
			}
		}
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
	
	@ViewBuilder
	private func contextMenu(for task: TaskRowViewModel) -> some View {
		Section {
			Button {
				print("Mark as Done")
			} label: {
				HStack {
					Text("Mark as Done")
					Image(systemName: "checkmark.square.fill")
						.symbolRenderingMode(.palette)
						.foregroundStyle(Color.white, Color.black)
				}
			}
			Button {
				print("Edit")
			} label: {
				Label("Edit", systemImage: "pencil")
			}
			Button {
				print("Set Reminder")
			} label: {
				Label("Set Reminder", systemImage: "bell.fill")
			}
		}
		Menu {
			Button("🏠 Home") {}
			Button("🏥 Health") {}
			Button("🛍️ Shopping") {}
			Button("🗂️ Work") {}
		} label: {
			Text("🏠 Category")
			Text("Home")
		}
		Section {
			Button {
				print("Duplicate")
			} label: {
				Label("Duplicate", systemImage: "plus.square.on.square")
			}
			Button {
				print("Delete Task")
			} label: {
				HStack {
					Text("Delete Task")
					Image(systemName: "trash.fill")
						.symbolRenderingMode(.palette)
				}
				.foregroundStyle(Color.red)
			}
		}
	}
}

// MARK: - ToolbarItems
extension TaskListView {
	@ToolbarContentBuilder
	private var addTaskToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .bottomBar) {
			Image(systemName: "plus")
				.foregroundStyle(Color.white)
				.typography(.sfSymbolM)
				.frame(width: 48, height: 48)
				.contentShape(Circle())
				.onTapGesture {
					onAddTaskTapped()
				}
				.glassEffect(.regular.interactive().tint(Color.accentGreen))
		}
		.sharedBackgroundVisibility(.hidden)
	}
	
	@ToolbarContentBuilder
	private var settingsToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .topBarTrailing) {
			Button(action: onSettingsTapped) {
				Image(.control)
			}
		}
	}
	
	@ToolbarContentBuilder
	private var paywallToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			Button(action: onSettingsTapped) {
				HStack(spacing: .x1) {
					Image(systemName: "star.square.fill")
						.typography(.sfSymbolL)
						.foregroundStyle(Color.accentIndigo)
					Text("PRO")
						.typography(.smallLabel)
						.foregroundStyle(Color.textPrimary)
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
	
	private func onAddCategoryTapped() {
		router.present(.newCategory)
	}
}
