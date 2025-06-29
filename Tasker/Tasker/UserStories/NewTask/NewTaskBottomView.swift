//
//  NewTaskBottomView.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import SwiftUI
import MokayUI

struct NewTaskBottomView: View {
	
//	enum State: CaseIterable {
//		case initial
//		case categoryPicker
//		case datePicker
//		case reminder
//	}
	
//	@SwiftUI.State private var state: State = .initial
	
	var newTaskFocusState: FocusState<NewTaskFocusState?>.Binding
    let keyboardHeight: CGFloat
    let maxKeyboardHeight: CGFloat
    let selectedDate: Binding<Date>
    let onAddTask: () -> Void
    
    var body: some View {
        VStack(spacing: .zero) {
            buttonsView
            contentView
        }
    }
    
    private var buttonsView: some View {
        VStack(spacing: .zero) {
            CustomizationButtonsView(
				newTaskFocusState: newTaskFocusState,
                onCategoryTap: {
                    withAnimation(.spring(.smooth(duration: 0.2, extraBounce: 0))) {
						newTaskFocusState.wrappedValue = .category
//						newTaskFocusState = .category
                    }
                },
                onDateTap: {
                    withAnimation(.spring(.smooth(duration: 0.2, extraBounce: 0))) {
						newTaskFocusState.wrappedValue = .date
//						newTaskFocusState = .date
                    }
                },
                onReminderTap: {
                    withAnimation(.spring(.smooth(duration: 0.2, extraBounce: 0))) {
						newTaskFocusState.wrappedValue = .reminder
//						newTaskFocusState = .reminder
                    }
                }
            )
            NewTaskCreateButtonView(onTap: onAddTask)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
//        ZStack {
			switch newTaskFocusState.wrappedValue {
			case .keyboard, nil:
                VStack(spacing: .zero) {
                    Color.clear
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 100)
                
            case .category:
                VStack(spacing: .zero) {
                    Text("Выбор категории")
                        .typography(.h2)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 300)
                .background(Color.orange)
                
            case .date:
//                VStack(spacing: .zero) {
//                    Spacer()
                    DatePicker(
                        "Выберите дату",
                        selection: selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
//					.frame(minHeight: 300)
//                }
//                .frame(maxWidth: .infinity)
//                .frame(maxHeight: .infinity)
                
            case .reminder:
                VStack(spacing: .zero) {
                    Text("Напоминание")
                        .typography(.h2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(maxHeight: 300)
                .background(Color.blue)
            }
//        }
//        .transition(.move(edge: .bottom))
    }
} 
