//
//  NotificationsViewModel.swift
//  Tasker
//
//  Created by Andrei Kozlov on 02/02/25.
//

import Combine
import SwiftUI
import UIKit

@MainActor
@Observable
final class NotificationsViewModel {
    
    var sections: [NotificationSection] = []
    
    // Notification settings
    var isRecommendationsEnabled: Bool = true
    var isUpcomingTasksEnabled: Bool = true
    var isOtherNewsEnabled: Bool = false
    
    init() {
        sections = buildSections()
    }
    
    // MARK: - Public methods
    
    func openSystemSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    // MARK: - Private methods
    
    private func buildSections() -> [NotificationSection] {
        return [
            NotificationSection(
                id: UUID(),
                items: [
                    NotificationItem(
                        id: UUID(),
                        type: .recommendations,
                        title: "Recommendations",
                        subtitle: nil,
                        showToggle: true
                    ),
                    NotificationItem(
                        id: UUID(),
                        type: .upcomingTasks,
                        title: "Upcoming tasks",
                        subtitle: nil,
                        showToggle: true
                    ),
                    NotificationItem(
                        id: UUID(),
                        type: .other,
                        title: "Other",
                        subtitle: "News from us",
                        showToggle: true
                    )
                ]
            )
        ]
    }
}

// MARK: - Models

struct NotificationSection: Identifiable {
    let id: UUID
    let items: [NotificationItem]
}

struct NotificationItem: Identifiable {
    let id: UUID
    let type: NotificationType
    let title: String
    let subtitle: String?
    let showToggle: Bool
    

}

enum NotificationType {
    case recommendations
    case upcomingTasks
    case other
}
