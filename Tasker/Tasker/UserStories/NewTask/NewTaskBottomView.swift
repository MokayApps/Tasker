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
	
	func onAddTask() {
		
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
	
	var body: some View {
		VStack(spacing: .zero) {
			buttonsView
			contentView
		}
	}
	
	private var buttonsView: some View {
		VStack(spacing: .zero) {
			CustomizationButtonsView(
				onCategoryTap: {
					withAnimation(.spring(.smooth(duration: 0.2, extraBounce: 0))) {
						viewModel.viewState = .categoryPicker
					}
				},
				onDateTap: {
					withAnimation(.spring(.smooth(duration: 0.2, extraBounce: 0))) {
						viewModel.viewState = .datePicker
					}
				},
				onReminderTap: {
					withAnimation(.spring(.smooth(duration: 0.2, extraBounce: 0))) {
						viewModel.viewState = .reminder
					}
				}
			)
			NewTaskCreateButtonView(onTap: viewModel.onAddTask)
		}
	}
	
	@ViewBuilder
	private var contentView: some View {
		switch viewModel.viewState {
		case .initial:
			EmptyView()
				.matchedGeometryEffect(id: .geometryId, in: animationNamespace)
		case .categoryPicker:
			VStack(spacing: .zero) {
				Text("Выбор категории")
					.typography(.h2)
			}
			.frame(maxWidth: .infinity)
			.frame(maxHeight: 300)
			.background(Color.orange)
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
