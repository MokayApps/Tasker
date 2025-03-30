//
//  SettingsRowView.swift
//  Tasker
//
//  Created by Дмитрий Бондаренко on 28.01.2025.
//

import SwiftUI
import MokayUI

struct SettingsRow: View {
    
    @ObservedObject var viewModel: SettingsRowViewModel
    
    var body: some View {
            CellView(
                leadingItem: {
                    if let color = viewModel.leadingImageColor {
                        Image(systemName: viewModel.leadingImageName)
                            .foregroundStyle(color)
                            .frame(width: .x3, height: .x3)
                    } else {
                        Image(systemName: viewModel.leadingImageName)
                            .frame(width: .x3, height: .x3)
                    }
                },
                trailingItem: {
                    switch viewModel.trailingViewType {
                    case let .image(name):
                        Image(systemName: name)
                            .foregroundStyle(.gray.opacity(0.6))
                            .frame(width: .x3, height: .x3)
                    case ._switch:
                        Toggle("", isOn: $viewModel.isToggleEnabled)
                    }
                },
                text: viewModel.title,
                description: viewModel.subtitle,
                showRedDot: false
            )
            .frame(maxWidth: .infinity, maxHeight: 72)
        
    }
    
}
