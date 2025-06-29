//
//  CustomizationButtonsView.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import SwiftUI
import MokayUI

struct CustomizationButtonsView: View {
	var newTaskFocusState: FocusState<NewTaskFocusState?>.Binding
    let onCategoryTap: () -> Void
    let onDateTap: () -> Void
    let onReminderTap: () -> Void
    
    var body: some View {
        HStack(spacing: .x1) {
            CustomizationButton(
                icon: "number.circle.fill",
                title: "CATEGORY",
                action: onCategoryTap
            )
			.focusable()
			.focused(newTaskFocusState, equals: .category)

            CustomizationButton(
                icon: "calendar.badge.plus",
                title: "DATE",
                action: onDateTap
            )
			.focusable()
			.focused(newTaskFocusState, equals: .date)

            CustomizationButton(
                icon: "bell",
                title: "REMINDER",
                action: onReminderTap
            )
			.focusable()
			.focused(newTaskFocusState, equals: .reminder)

        }
        .frame(height: 60)
        .padding(.horizontal, .x2)
    }
}

struct CustomizationButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: .zero) {
                Image(systemName: icon)
                    .typography(.sfSymbolL)
                Text(title)
                    .typography(.smallLabel)
            }
            .foregroundStyle(Color.accent.primary)
            .frame(maxWidth: .infinity)
            .padding(.top, .x1)
            .padding(.bottom, .x05)
            .background {
                RoundedRectangle(cornerRadius: 17)
                    .foregroundStyle(Color.accent.bgSecondary)
            }
        }
    }
} 
