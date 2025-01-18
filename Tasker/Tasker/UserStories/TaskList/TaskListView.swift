//
//  TaskListView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import MokayUI
import SwiftUI
import SwiftData

struct TaskListView: View {
    
    let viewModel: TaskListViewModel
    @Environment(Router.self) var router
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [Task]
    
    private let gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: 300), spacing: .x1),
        GridItem(.flexible(minimum: 100, maximum: 300), spacing: .x1)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.tasks) { task in
                    TaskRow(viewModel: task)
                    //                NavigationLink {
                    //                    Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    //                } label: {
                    //                    Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    //                }
                }
            }
            .padding(.x2)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onSettingsTapped) {
                        Image(systemName: "gearshape.fill")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onSearchTapped) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Tasker")
    }
    
    
    private func onSettingsTapped() {
        router.push(.settings)
    }

    private func onSearchTapped() {
        router.push(.search)
    }
}
