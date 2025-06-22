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
	
	private let gridItems: [GridItem] = [
		GridItem(.flexible(minimum: 100, maximum: 300), spacing: .x1),
		GridItem(.flexible(minimum: 100, maximum: 300), spacing: .x1)
	]
	
	var body: some View {
		ZStack {
			switch viewModel.viewState {
			case .idle:
				Color.white.onAppear(perform: viewModel.onAppear)
			case .loading:
				ProgressView().progressViewStyle(.circular)
			case .loaded(let tasks) where tasks.isEmpty:
				emptyStateView
			case .loaded(let tasks):
				ZStack(alignment: .bottomTrailing) {
					ScrollView {
						LazyVGrid(columns: gridItems) {
							ForEach(tasks) { task in
								TaskRow(viewModel: task)
							}
						}
						.padding(.x2)
					}
					addTaskButton
						.offset(x: -.x3)
				}
			case .error:
				ContentUnavailableView {
					Label("Error while loading tasks", systemImage: "network.slash")
				} actions: {
					Button("Reload", action: viewModel.reload)
						.buttonStyle(.primaryMedium)
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Tasker")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(action: onSettingsTapped) {
					Image("control")
				}
				.buttonStyle(.secondarySmall)
			}
			ToolbarItem(placement: .topBarLeading) {
				Button(action: onSearchTapped) {
					Image("search")
				}
				.buttonStyle(.secondarySmall)
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
	
	private func onSettingsTapped() {
		router.push(.settings)
	}
	
	private func onSearchTapped() {
		router.present(.search)
	}
	
	private func onAddTaskTapped() {
		router.present(.newTask)
	}
}
