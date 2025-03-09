//
// SettingsViewModel.swift
//  Tasker
//
//  Created by Дмитрий Бондаренко on 28.01.2025.
//

import Combine
import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    
    var sections: [SettingsSection] = []
    
    var isFaceIdEnabled: Bool = false
    
    let rowTappedSubject = PassthroughSubject<SettingsRowType, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        sections = buildSections()
        setupBindings()
    }
    
    // MARK: - Private methods
    
    private func buildSections() -> [SettingsSection] {
        return [
            SettingsSection(
                id: UUID(),
                title: "APP",
                rows: [
                    SettingsRowViewModel(id: UUID(), type: .categories),
                    SettingsRowViewModel(id: UUID(), type: .notifications),
                    SettingsRowViewModel(id: UUID(), type: .appearance),
                    SettingsRowViewModel(id: UUID(), type: .faceID, isLastInSection: true, isToggleEnabled: isFaceIdEnabled)
                ]
            ),
            SettingsSection(
                id: UUID(),
                title: "CONTACT US",
                rows: [
                    SettingsRowViewModel(id: UUID(), type: .telegram),
                    SettingsRowViewModel(id: UUID(), type: .email),
                    SettingsRowViewModel(id: UUID(), type: .rateApp, isLastInSection: true)
                ]
            ),
            SettingsSection(
                id: UUID(),
                title: nil,
                rows: [
                    SettingsRowViewModel(id: UUID(), type: .about),
                    SettingsRowViewModel(id: UUID(), type: .faq),
                    SettingsRowViewModel(id: UUID(), type: .termsOfService),
                    SettingsRowViewModel(id: UUID(), type: .privacyPolicy, isLastInSection: true)
                ]
            )
        ]
    }
    
    private func setupBindings() {
        rowTappedSubject
            .sink { [weak self] type in
                self?.handleRowTap(type)
            }
            .store(in: &cancellables)
    }
    
    private func handleRowTap(_ type: SettingsRowType) {
        
    }
    
}
