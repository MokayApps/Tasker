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
	case category
	case date
	case reminder
}

struct NewTaskView: View {
	
	@StateObject var viewModel: NewTaskViewModel
	
	@Environment(Router.self) var router
	@Environment(\.dismiss) private var dismiss
	@FocusState private var newTaskFocusState: NewTaskFocusState?
	
	@State private var keyboardHeight: CGFloat = 0
	@State private var maxKeyboardHeight: CGFloat = 0
	
	var body: some View {
		VStack {
//			NewTaskNameInputView(
//				taskName: viewModel.taskNameBinding
////				newTaskFocusState: $newTaskFocusState
//			)
			TextField("123", text: .constant("333"))
				.focused($newTaskFocusState, equals: .keyboard)
			
			TextField("123", text: .constant("555"))
				.focused($newTaskFocusState, equals: .category)
			Spacer()
			
//			NewTaskBottomView(
//				newTaskFocusState: $newTaskFocusState,
//				keyboardHeight: keyboardHeight,
//				maxKeyboardHeight: maxKeyboardHeight,
//				selectedDate: viewModel.selectedDateBinding,
//				onAddTask: viewModel.addTask
//			)
//			.background(Color.red)
//			.focused($newTaskFocusState, equals: .category)

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
			newTaskFocusState = .keyboard
		}
		.onChange(of: newTaskFocusState) { oldValue, newValue in
			print("Focus state changed from \(String(describing: oldValue)) to \(String(describing: newValue))")
		}
	}
	
	func onCloseTapped() {
//		dismiss()
		newTaskFocusState = .category
	}
}
