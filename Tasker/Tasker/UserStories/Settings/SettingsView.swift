//
//  SettingsView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import SwiftUI
import MokayUI

struct SettingsView: View {
    var viewModel: SettingsViewModel
    @Environment(Router.self) var router
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.sections) { section in
                if let title = section.title {
                    HeaderView(
                        text: title,
                        color: .gray,
                        style: .caption
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .x2)
                }
                
                VStack(spacing: .zero) {
                    ForEach(section.rows) { row in
                        SettingsRow(viewModel: row)
							.contentShape(Rectangle())
                            .onTapGesture {
                                if row.type == .categories {
                                    router.push(.categories)
                                }
                                viewModel.rowTappedSubject.send(row.type)
                            }
                        if !row.isLastInSection {
                            Divider()
                                .background(Color.gray.opacity(0.1))
                                .frame(height: 1)
                        }
                    }
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(.x3)
                .padding(.horizontal, .x2)
                .padding(.bottom, .x2)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}

