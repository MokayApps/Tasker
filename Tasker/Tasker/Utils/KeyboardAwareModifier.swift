//
//  KeyboardAwareModifier.swift
//  Tasker
//
//  Created by Єгор Привалов on 11.04.2025.
//

import Combine
import SwiftUI

struct KeyboardAwareModifier: ViewModifier {
	@AppStorage("keyboardHeight") private var savedKeyboardHeight: Double = Double(UIScreen.main.bounds.height / 2.5)
	var customHeight: CGFloat?
	var showToolbar: Bool
	
	@State private var keyboardHeight: CGFloat = 0
	
	private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
		Publishers.Merge(
			NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
				.compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
				.map { $0.cgRectValue.height },
			NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
				.map { _ in CGFloat(0) }
		).eraseToAnyPublisher()
	}
	
	func body(content: Content) -> some View {
		content
			.frame(height: customHeight ?? CGFloat(savedKeyboardHeight))
			.onReceive(keyboardHeightPublisher) { value in
				withAnimation(.easeInOut(duration: 0.3)) {
					if value > 200 {
						self.savedKeyboardHeight = Double(value)
					}
					self.keyboardHeight = value
				}
			}
	}
}


extension View {
	func keyboardAwareHeight(customHeight: CGFloat? = nil, showToolbar: Bool = false) -> some View {
		self.modifier(KeyboardAwareModifier(customHeight: customHeight, showToolbar: showToolbar))
	}
}
