//
//  NewTaskBottomView.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import SwiftUI
import MokayUI
import UIKit

final class NewTaskBottomViewModel: ObservableObject {
	
	@Published var viewState: NewTaskBottomView.ViewState = .initial
	@Published var selectedDate: Date = Date()
	var onAddTaskCompletion: (() -> Void)?
	
	func onAddTask() {
		onAddTaskCompletion?()
	}
	
}

struct NewTaskBottomView: View {
	
	enum ViewState: CaseIterable {
		case initial
		case categoryPicker
		case datePicker
		case reminder
	}
	
	@ObservedObject var viewModel: NewTaskBottomViewModel
	@Namespace private var animationNamespace
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		VStack(spacing: .zero) {
			buttonsView
			contentView
		}
	}
	
	private var buttonsView: some View {
		VStack(spacing: .zero) {
			HStack(spacing: .x1) {
				Button {
					withAnimation(.spring(.smooth(duration: 0.2, extraBounce: 0))) {
						viewModel.viewState = .categoryPicker
					}
				} label: {
					VStack(spacing: .zero) {
						Image(systemName: "number.circle.fill")
							.typography(.sfSymbolL)
						Text("CATEGORY")
					}
				}
				.buttonStyle(.newTask(isSelected: viewModel.viewState == .categoryPicker))
				
				Button {
					withAnimation(.spring(.smooth(duration: 0.2, extraBounce: 0))) {
						viewModel.viewState = .datePicker
					}
				} label: {
					VStack(spacing: .zero) {
						Image(systemName: "calendar.badge.plus")
							.typography(.sfSymbolL)
						Text("DATE")
					}
				}
				.buttonStyle(.newTask(isSelected: viewModel.viewState == .datePicker))

				Button {
					withAnimation(.spring(.smooth(duration: 0.2, extraBounce: 0))) {
						viewModel.viewState = .reminder
					}
				} label: {
					VStack(spacing: .zero) {
						Image(systemName: "bell")
							.typography(.sfSymbolL)
						Text("REMINDER")
					}
				}
				.buttonStyle(.newTask(isSelected: viewModel.viewState == .reminder))
			}
			.padding(.horizontal, .x2)
			
			NewTaskCreateButtonView {
				viewModel.onAddTask()
				dismiss()
			}
		}
	}
	
	@ViewBuilder
	private var contentView: some View {
		switch viewModel.viewState {
		case .initial:
			EmptyView()
				.matchedGeometryEffect(id: .geometryId, in: animationNamespace)
		case .categoryPicker:
			NewTaskCategoryView()
				.frame(maxWidth: .infinity)
				.frame(maxHeight: 300)
				.background {
					UnevenRoundedRectangle(
						topLeadingRadius: .r3,
						bottomLeadingRadius: .zero,
						bottomTrailingRadius: .zero,
						topTrailingRadius: .r3,
						style: .continuous
					)
					.foregroundStyle(Color.bgMain)
				}
				.overlay {
					UnevenRoundedRectangle(
						topLeadingRadius: .r3,
						bottomLeadingRadius: .zero,
						bottomTrailingRadius: .zero,
						topTrailingRadius: .r3,
						style: .continuous
					)
					.stroke()
					.foregroundStyle(Color.stroke)
				}
				.matchedGeometryEffect(id: .geometryId, in: animationNamespace)
		case .datePicker:
			DatePicker(
				"Выберите дату",
				selection: $viewModel.selectedDate,
				displayedComponents: [.date]
			)
			.datePickerStyle(.graphical)
			.matchedGeometryEffect(id: .geometryId, in: animationNamespace)
		case .reminder:
			VStack(spacing: .zero) {
				Text("Напоминание")
					.typography(.h2)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.frame(maxHeight: 300)
			.background(Color.blue)
			.matchedGeometryEffect(id: .geometryId, in: animationNamespace)
		}
	}
}

extension Hashable where Self == String {
	
	fileprivate static var geometryId: String { "NewTaskBottomView.geometryId" }
}
