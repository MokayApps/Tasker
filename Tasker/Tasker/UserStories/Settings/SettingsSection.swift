//
//  SettingsSection.swift
//  Tasker
//
//  Created by Дмитрий Бондаренко on 29.01.2025.
//

import Foundation

struct SettingsSection: Identifiable {
    
    let id: UUID
    let title: String?
    let rows: [SettingsRowViewModel]
    
}
