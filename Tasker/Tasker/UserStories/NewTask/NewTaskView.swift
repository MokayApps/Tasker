//
//  NewTaskView.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import Foundation
import SwiftUI
import MokayUI
import Combine

enum NewTaskFocusState: Hashable {
	case keyboard
}

struct NewTaskView: View {
	
	@StateObject var viewModel: NewTaskViewModel
	
	@Environment(Router.self) var router
	@Environment(\.dismiss) private var dismiss
	@FocusState var isKeyboardShown: Bool
	
	var body: some View {
		VStack {
			NewTaskNameInputView(taskName: $viewModel.taskName)
				.focused($isKeyboardShown)
				.bind($viewModel.isKeyboardShown, with: _isKeyboardShown)
			
			Spacer()
			
			NewTaskBottomView(viewModel: viewModel.bottomViewModel)
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("New Task")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(action: onCloseTapped) {
					Image("close")
				}
				.buttonStyle(.secondarySmall)
			}
		}
		.onAppear {
			isKeyboardShown = true
		}
	}
	
	func onCloseTapped() {
		dismiss()
	}
}
