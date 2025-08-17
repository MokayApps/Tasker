//
//  NewTaskRemindView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 17.08.2025.
//

import SwiftUI
import MokayUI

struct NewTaskRemindView: View {
	
	@StateObject var viewModel = NewTaskRemindViewModel()
	
    var body: some View {
		ScrollView {
			VStack(spacing: .x1) {
				ForEach(viewModel.items) { item in
					Button {
						print("Selected item: \(item.title)")
					} label: {
						Text(item.title)
							.foregroundColor(.textPrimary)
							.padding(.x2)
					}
					.buttonStyle(.newTask(isSelected: true))
				}
			}
			.padding(.x1)
		}
    }
}

#Preview {
    NewTaskRemindView()
}
