//
//  SettingsRowViewModel.swift
//  Tasker
//
//  Created by Дмитрий Бондаренко on 28.01.2025.
//

import Foundation
import SwiftUI

class SettingsRowViewModel: Identifiable, ObservableObject {
    
    let id: UUID
    let type: SettingsRowType
    let isLastInSection: Bool
    
    @Published var isToggleEnabled: Bool
    
    // MARK: - Init
    
    init(
        id: UUID,
        type: SettingsRowType,
        isLastInSection: Bool = false,
        isToggleEnabled: Bool = false
    ) {
        self.id = id
        self.type = type
        self.isLastInSection = isLastInSection
        self.isToggleEnabled = isToggleEnabled
    }
    
    var leadingImageName: String {
        switch type {
        case .categories:
            "number.circle.fill"
        case .notifications:
            "app.badge.fill"
        case .appearance:
            "paintbrush.fill"
        case .faceID:
            "faceid"
        case .telegram:
            "telegram"
        case .email:
            "envelope.fill"
        case .rateApp:
            "appStore"
        case .about:
            "info.circle.fill"
        case .faq, .termsOfService, .privacyPolicy:
            "book.closed.fill"
        }
    }
    
    var leadingImageColor: Color? {
        switch type {
        case .categories:
            .purple
        case .notifications:
            .orange
        case .appearance:
            .green
        case .faceID:
            .blue
        case .email:
            .purple
        case .about:
            .blue
        case .faq, .termsOfService, .privacyPolicy:
            .green
        default:
            nil
        }
    }
    
    var title: String {
        switch type {
        case .categories:
            "Categories"
        case .notifications:
            "Notifications"
        case .appearance:
            "Appearance"
        case .faceID:
            "Face ID"
        case .telegram:
            "Telegram"
        case .email:
            "Email"
        case .rateApp:
            "Rate App"
        case .about:
            "About App"
        case .faq:
            "FAQ"
        case .termsOfService:
            "Terms of Service"
        case .privacyPolicy:
            "Privacy Policy"
        }
    }
    var subtitle: String? {
        switch type {
        case .about:
            if let versionValue = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return "Version " + versionValue
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    var trailingViewType: SettingsRowTrailingViewType {
        switch type {
        case .faceID:
            return ._switch
        default:
            return .image(name: getTrailingImageName(for: type))
        }
    }
    
    // MARK: - Private methods
    
    private func getTrailingImageName(for type: SettingsRowType) -> String {
        switch type.actionType {
        case .transition:
            "chevron.right"
        case .link:
            "arrow.up.right"
        default:
            ""
        }
    }
    
}
