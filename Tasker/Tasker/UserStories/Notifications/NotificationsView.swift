//
//  NotificationsView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 02/02/25.
//

import SwiftUI
import MokayUI

struct NotificationsView: View {
    @Bindable var viewModel: NotificationsViewModel
    @Environment(Router.self) var router
    
    var body: some View {
        ScrollView {
            VStack(spacing: .x2) {
                VStack(spacing: .zero) {
                    NotificationRow(
                        title: "Recommendations",
                        subtitle: nil,
                        isToggleOn: $viewModel.isRecommendationsEnabled,
                        showToggle: true
                    )
                    
                    Divider()
                        .background(Color.gray.opacity(0.1))
                        .frame(height: 1)
                    
                    NotificationRow(
                        title: "Upcoming tasks",
                        subtitle: nil,
                        isToggleOn: $viewModel.isUpcomingTasksEnabled,
                        showToggle: true
                    )
                    
                    Divider()
                        .background(Color.gray.opacity(0.1))
                        .frame(height: 1)
                    
                    NotificationRow(
                        title: "Other",
                        subtitle: "News from us",
                        isToggleOn: $viewModel.isOtherNewsEnabled,
                        showToggle: true
                    )
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(.x3)
                .padding(.horizontal, .x2)
                
                // Don't miss important section
                VStack(alignment: .leading, spacing: .x2) {
                    Text("Don't miss important")
                        .typography(.h4)
                        .foregroundStyle(.primary)
                    
                    Text("Customize notifications so that you are comfortable, but do not miss important messages from the application")
                        .typography(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, .x2)
                .padding(.top, .x2)
                
                // Open Settings App Button
                Button(action: viewModel.openSystemSettings) {
                    HStack {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.gray)
                        
                        Text("OPEN SETTINGS APP")
                            .typography(.mediumLabel)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal, .x2)
                    .padding(.vertical, .x2)
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(.x3)
                .padding(.horizontal, .x2)
                .padding(.bottom, .x2)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Notifications")
    }
}

private struct NotificationRow: View {
    let title: String
    let subtitle: String?
    let isToggleOn: Binding<Bool>
    let showToggle: Bool
    
    var body: some View {
        CellView(
            leadingItem: { EmptyView() },
            trailingItem: {
                if showToggle {
                    Toggle("", isOn: isToggleOn)
                }
            },
            text: title,
            description: subtitle,
            showRedDot: false
        )
        .frame(maxWidth: .infinity, maxHeight: 72)
    }
}

#Preview {
    NavigationView {
        NotificationsView(viewModel: NotificationsViewModel())
    }
}
