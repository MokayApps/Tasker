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
				ScrollView {
					LazyVGrid(columns: gridItems) {
						ForEach(tasks) { task in
							TaskRow(viewModel: task)
						}
					}
					.padding(.x2)
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
					Button("Add task") {
						router.present(.newTask)
					}
					.buttonStyle(.primaryMedium)
				}
			)
			Spacer()
		}
	}
	
	private func onSettingsTapped() {
		router.push(.settings)
	}
	
	private func onSearchTapped() {
		router.present(.search)
	}
}
