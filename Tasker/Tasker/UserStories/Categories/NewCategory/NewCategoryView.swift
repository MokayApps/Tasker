//
//  NewCategoryView.swift
//  Tasker
//
//  Created by Roman Apanasevich on 02.02.2025.
//

import SwiftUI
import MokayUI

struct NewCategoryView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(Router.self) var router
	@StateObject var viewModel: NewCategoryViewModel
	@FocusState private var isFocused: Bool
	@FocusState private var isEmojiFocused: Bool
	
	private let colors: [Color] = [.green, .yellow, .orange, .red, .pink, .purple, .blue, .teal, .gray, .brown, .cyan, .mint, .indigo, .black]
	private let columns = Array(repeating: GridItem(.flexible(), spacing: .x2), count: 7)
	
	var body: some View {
		ZStack(alignment: .bottom) {
			VStack {
				Spacer()
					.frame(height: .x2)
				
				headerView()
					.frame(height: 40)
					.padding(.horizontal, .x2)
					.padding(.bottom, .x2)
				
				HStack(spacing: .x2) {
					CustomKeyboardTextfield(input: $viewModel.emoji, keyboardHeight: 300)
						.focused($isEmojiFocused)
						.padding(18.5)
						.frame(width: 63, height: 63)
						.background {
							RoundedRectangle(cornerRadius: .x3)
								.fill(Color.black.opacity(0.04))
						}
					
					InputView(text: $viewModel.trackerCategory, placeholder: "Category")
						.inputViewStyle(.large)
						.focused($isFocused)
						.frame(maxWidth: .infinity)
						.frame(height: 63)
				}
				.padding(.horizontal, .x2)
				
				LazyVGrid(columns: columns, spacing: .x2) {
					ForEach(colors, id: \.self) { color in
						ZStack {
							Circle()
								.stroke(viewModel.selectedColor == color ? color : .clear, lineWidth: 4)
								.frame(width: 40, height: 40)
							
							Circle()
								.fill(color)
								.frame(width: .x3, height: .x3)
						}
						.simultaneousGesture(
							TapGesture()
								.onEnded {
									withAnimation {
										viewModel.selectedColor = color
									}
								}
						)
					}
				}
				.padding(.horizontal, 28.75)
				.padding(.top, .x2)
				
				Spacer()
			}
			.contentShape(Rectangle())
			.onTapGesture {
				isFocused = false
				isEmojiFocused = false
			}
			.onAppear {
				let range = 0x1F601...0x1F64F
				let randomEmojiCodePoint = range.randomElement() ?? 0x1F60D
				let emoji = UnicodeScalar(randomEmojiCodePoint)?.description ?? "🍑"
				viewModel.emoji = emoji
				
				DispatchQueue.main.async {
					self.viewModel.selectedColor = colors.randomElement()
				}
			}
			
			saveButton()
				.frame(height: 56)
				.background {
					RoundedRectangle(cornerRadius: 17)
						.foregroundStyle(Color.green)
				}
				.padding(.horizontal, .x2)
				.padding(.bottom, .x2)
		}
	}
	
	@ViewBuilder
	private func headerView() -> some View {
		ZStack {
			Text("New Category")
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
	
	@ViewBuilder
	private func saveButton() -> some View {
		Button {
			viewModel.addCategory()
			dismiss()
		} label: {
			HStack {
				Text("Save")
					.typography(.mediumLabel)
					.foregroundStyle(Color.white)
				
				Spacer()
				
				Image(.done)
					.foregroundStyle(Color.white)
			}
			.padding(.horizontal, .x3)
		}
	}
}

//#Preview {
//	NewCategoryView()
//		.environment(Router(container: .main))
//}

fileprivate struct CustomKeyboardTextfield: UIViewRepresentable {
	
	@Binding var input: String
	var keyboardHeight: CGFloat
	
	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.text = input
		textField.font = .systemFont(ofSize: 26)
		textField.delegate = context.coordinator
		textField.tintColor = .clear
		textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
		textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
		
		let emojiKeyboardView = EmojiKeyboardView(
			insertText: { text in
				textField.text = "\(textField.text ?? "")\(text)"
			},
			keyboardHeight: keyboardHeight
		)
		
		let inputView = UIInputView()
		
		// TODO: Тут закругление для пикера эможи
		inputView.backgroundColor = .clear
		emojiKeyboardView.backgroundColor = .systemBackground
		inputView.layer.cornerCurve = .continuous
		emojiKeyboardView.layer.cornerCurve = .continuous
		
		emojiKeyboardView.layer.cornerRadius = 16
		emojiKeyboardView.clipsToBounds = true
		inputView.layer.cornerRadius = 16
		inputView.clipsToBounds = true
		
		inputView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: keyboardHeight))
		
		inputView.addSubview(emojiKeyboardView)
		emojiKeyboardView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			emojiKeyboardView.topAnchor.constraint(equalTo: inputView.topAnchor),
			emojiKeyboardView.leadingAnchor.constraint(equalTo: inputView.leadingAnchor),
			emojiKeyboardView.trailingAnchor.constraint(equalTo: inputView.trailingAnchor),
			emojiKeyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor)
		])
		
		textField.inputView = inputView
		return textField
	}
	
	func updateUIView(_ uiView: UITextField, context: Context) {
		uiView.text = input
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, UITextFieldDelegate {
		var parent: CustomKeyboardTextfield
		
		init(_ control: CustomKeyboardTextfield) {
			self.parent = control
			super.init()
		}
		
		func textFieldDidChangeSelection(_ textField: UITextField) {
			guard let text = textField.text else { return }
			let lastChar = String(text.suffix(1))
			textField.text = lastChar
			parent.input = lastChar
		}
		
		func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			textField.resignFirstResponder()
			return true
		}
	}
}
