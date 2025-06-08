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

struct NewTaskView: View {
	
	enum BottomViewState: CaseIterable {
		case initial, categoryPicker, datePicker, reminder
	}
	
	@StateObject var viewModel: NewTaskViewModel
	
	@Environment(Router.self) var router
	@Environment(\.dismiss) private var dismiss
	@FocusState private var isTextFieldFocused: Bool
	
	@State private var keyboardHeight: CGFloat = 0
	@State private var maxKeyboardHeight: CGFloat = 0
	@State private var bottomViewState: BottomViewState = .initial
	
	private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
		Publishers.Merge(
			NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
				.compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
				.map { $0.cgRectValue.height },
			NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
				.map { _ in CGFloat(0) }
		).eraseToAnyPublisher()
	}
	
	private var computedBottomPadding: CGFloat {
		switch bottomViewState {
		case .initial:
			return keyboardHeight > 0 ? keyboardHeight : .x3
		case .categoryPicker:
			return maxKeyboardHeight
		case .datePicker:
			return 390
		case .reminder:
			return maxKeyboardHeight
		}
	}
	
	var body: some View {
		ZStack(alignment: .bottom) {
			headerView
			textField
			buttonsView
			bottomView
		}
		.ignoresSafeArea(.keyboard, edges: .bottom)
		.ignoresSafeArea()
		.onReceive(keyboardHeightPublisher) { value in
			withAnimation {
				keyboardHeight = value
				if value > 0 {
					maxKeyboardHeight = max(maxKeyboardHeight, value)
					if isTextFieldFocused {
						bottomViewState = .initial
					}
				}
			}
		}
		.onChange(of: isTextFieldFocused) { _, isFocused in
			if isFocused {
				withAnimation {
					bottomViewState = .initial
				}
			}
		}
		.onAppear {
			isTextFieldFocused.toggle()
		}
	}
}

extension NewTaskView {
	private var headerView: some View {
		VStack {
			VStack(spacing: .zero) {
				ZStack {
					Text("New Task")
						.typography(.h4)
					
					HStack {
						Spacer()
						
						Button {
							dismiss()
						} label: {
							Image(.close)
								.padding(8)
								.foregroundStyle(.black)
								.background {
									RoundedRectangle(cornerRadius: 17, style: .circular)
										.fill(Color.black.opacity(0.04))
								}
						}
					}
				}
			}
			.padding([.horizontal, .vertical], .x2)
			Spacer()
		}
	}
	
	private var textField: some View {
		VStack(spacing: .zero) {
			InputView(text: viewModel.taskNameBinding, placeholder: "Task name")
				.inputViewStyle(.large)
				.focused($isTextFieldFocused)
				.frame(maxWidth: .infinity)
				.frame(height: 63)
				.padding(.horizontal, .x2)
			Spacer()
		}
		.padding(.top, 72)
	}
	
	private var buttonsView: some View {
		VStack(spacing: .zero) {
			customisationsButtonsView
			createButton
		}
		.padding(.bottom, computedBottomPadding)
	}
	
	@ViewBuilder
	private var bottomView: some View {
		ZStack {
			switch bottomViewState {
			case .initial:
				VStack(spacing: .zero) {
					Color.clear
				}
				.frame(maxWidth: .infinity)
				
			case .categoryPicker:
				VStack(spacing: .zero) {
					Text("Выбор категории")
						.typography(.h2)
				}
				.frame(maxWidth: .infinity)
				.background(Color.orange)
				
			case .datePicker:
				VStack(spacing: .zero) {
					Spacer()
					DatePicker(
						"Выберите дату",
						selection: viewModel.selectedDateBinding,
						displayedComponents: [.date]
					)
					.datePickerStyle(.graphical)
				}
				.frame(maxWidth: .infinity)
			case .reminder:
				VStack(spacing: .zero) {
					Text("Напоминание")
						.typography(.h2)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.blue)
			}
		}
		.compositingGroup()
		.frame(maxHeight: {
			switch bottomViewState {
			case .initial:
				return isTextFieldFocused ? keyboardHeight : 0
			case .datePicker:
				return .infinity
			default:
				return maxKeyboardHeight
			}
		}())
	}
}
	
extension NewTaskView {
	private var customisationsButtonsView: some View {
		HStack(spacing: .x1) {
			customisationButton(
				icon: "number.circle.fill",
				title: "CATEGORY",
				action: {
					withAnimation {
						bottomViewState = .categoryPicker
						isTextFieldFocused = false
					}
				}
			)

			customisationButton(
				icon: "calendar.badge.plus",
				title: "DATE",
				action: {
					withAnimation {
						bottomViewState = .datePicker
						isTextFieldFocused = false
					}
				}
			)

			customisationButton(
				icon: "bell",
				title: "REMINDER",
				action: {
					withAnimation {
						bottomViewState = .reminder
						isTextFieldFocused = false
					}
				}
			)
		}
		.frame(height: 60)
		.padding(.horizontal, .x2)
	}
	
	private var createButton: some View {
		Button {
			viewModel.addTask()
		} label: {
			HStack {
				Text("Create")
					.typography(.mediumLabel)
					.foregroundStyle(Color.white)
				
				Spacer()
				
				Image(.done)
					.renderingMode(.template)
					.foregroundStyle(Color.white)
			}
		}
		.buttonStyle(.primaryMedium)
		.backgroundStyle(Color.green)
		.padding(.x2)
	}

	@ViewBuilder
	private func customisationButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
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
