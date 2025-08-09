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

	@State private var keyboardHeight: CGFloat = 0
	@State private var maxKeyboardHeight: CGFloat = 0
	
	var body: some View {
		VStack {
			NewTaskNameInputView(
				taskName: viewModel.taskNameBinding
			)
			.focused($isKeyboardShown)
//			.focused($newTaskFocusState, equals: .keyboard)
//			TextField("123", text: .constant("333"))
//				.focused($newTaskFocusState, equals: .keyboard)
//			
//			TextField("123", text: .constant("555"))
//				.focused($newTaskFocusState, equals: .category)
//			Spacer()
			
			NewTaskBottomView(
				viewModel: viewModel.bottomViewModel
			)
			.background(Color.red)

//			.transition(.move(edge: .bottom))
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
			isKeyboardShown = viewModel.isKeyboardShown
		}
		.onChange(of: isKeyboardShown) { oldValue, newValue in
			guard oldValue != newValue else { return }
		   viewModel.isKeyboardShown = newValue
		}
		.onChange(of: viewModel.isKeyboardShown) { oldValue, newValue in
			guard oldValue != newValue else { return }
			guard newValue else { return }
			viewModel.bottomViewModel.viewState = .initial
		}
		.onChange(of: viewModel.bottomViewModel.viewState) { oldValue, newValue in
			guard oldValue != newValue else { return }
			switch newValue {
			case .categoryPicker, .datePicker, .reminder:
				isKeyboardShown = false
			case .initial:
				break
			}
		}
//		.onChange(of: newTaskFocusState) { oldValue, newValue in
//			print("Focus state changed from \(String(describing: oldValue)) to \(String(describing: newValue))")
//		}
	}
	
	func onCloseTapped() {
		dismiss()
	}
}
