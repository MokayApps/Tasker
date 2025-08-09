//
//  View+Bind.swift
//  Tasker
//
//  Created by Andrei Kozlov on 09.08.2025.
//

import SwiftUI

// MARK: - View
extension View {

	/// https://stackoverflow.com/a/75237288
	public func bind<T: Equatable>(_ binding: Binding<T>, with focusState: FocusState<T>) -> some View {
		self
			.onChange(of: binding.wrappedValue) {
				focusState.wrappedValue = $0
			}
			.onChange(of: focusState.wrappedValue) {
				binding.wrappedValue = $0
			}
	}
}
