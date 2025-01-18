//
//  TaskListView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    
    @Environment(Router.self) var router
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                } label: {
                    Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                }
            }
        }
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
