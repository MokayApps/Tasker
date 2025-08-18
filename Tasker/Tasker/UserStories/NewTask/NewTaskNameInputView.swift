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

    var body: some View {
        VStack(spacing: .zero) {
            InputView(text: $taskName, placeholder: "Task name")
                .inputViewStyle(.large)
                .frame(maxWidth: .infinity)
                .frame(height: 63)
				.overlay {
					if taskName.isEmpty {
						RoundedRectangle(cornerRadius: 24)
							.stroke(Color.warning, lineWidth: 2)
					}
				}
                .padding(.horizontal, .x2)

            Spacer()
        }
    }
} 
