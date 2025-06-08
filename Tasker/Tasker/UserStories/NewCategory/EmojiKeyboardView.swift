//
//  EmojiKeyboardView.swift
//  Tasker
//
//  Created by Roman Apanasevich on 19.04.2025.
//

import SwiftUI

struct EmojiKeyboardView: View {
	var insertText: (String) -> Void
	
	let keyboardHeight: CGFloat
	
	private let emojis: [String] = Array(0x1F600...0x1F64F).compactMap { UnicodeScalar($0)?.description }
	
	private let columns = 5
	private let horizontalSpacing: CGFloat = 42
	private let verticalSpacing: CGFloat = 24
	private let verticalPadding: CGFloat = 16
	private let horizontalPadding: CGFloat = 24
	
	var body: some View {
		ScrollView {
			LazyVGrid(
				columns: Array(repeating: GridItem(.flexible(), spacing: horizontalSpacing), count: columns),
				spacing: verticalSpacing
			) {
				ForEach(emojis, id: \.self) { emoji in
					Button(action: {
						insertText(emoji)
					}, label: {
						Text(emoji)
							.font(.system(size: 30))
					})
				}
			}
			.padding(.vertical, verticalPadding)
			.padding(.horizontal, horizontalPadding)
		}
		.frame(height: keyboardHeight)
	}
}

struct NextKeyboardButtonOverlay: UIViewRepresentable {
	let action: Selector
	
	func makeUIView(context: Context) -> UIButton {
		let button = UIButton()
		button.addTarget(nil, action: action, for: .allTouchEvents)
		return button
	}
	func updateUIView(_ button: UIButton, context: Context) {}
}


#Preview {
	EmojiKeyboardView(insertText: {_ in}, keyboardHeight: 300)
}
