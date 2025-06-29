//
//  NewTaskNameInputView.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import SwiftUI
import MokayUI

struct NewTaskNameInputView: View {
    @Binding var taskName: String
//	var newTaskFocusState: FocusState<NewTaskFocusState?>.Binding

    var body: some View {
        VStack(spacing: .zero) {
            InputView(text: $taskName, placeholder: "Task name")
                .inputViewStyle(.large)
//				.focused(newTaskFocusState, equals: .keyboard)
                .frame(maxWidth: .infinity)
                .frame(height: 63)
                .padding(.horizontal, .x2)
            Spacer()
        }
//        .padding(.top, 72)
    }
} 
