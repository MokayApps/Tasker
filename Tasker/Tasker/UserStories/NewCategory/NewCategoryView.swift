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
	@StateObject private var viewModel = NewCategoryViewModel()
	@FocusState private var isFocused: Bool
	
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
					.focused($isFocused)
					.typography(.h3)
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
			
			shareButton()
				.frame(height: 56)
				.background {
					RoundedRectangle(cornerRadius: 17)
						.foregroundStyle(Color.green)
				}
				.padding(.horizontal, .x2)
				.padding(.vertical, .x2)
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
	private func shareButton() -> some View {
		Button {
			print("Save")
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

#Preview {
	NewCategoryView()
		.environment(Router(container: .main))
}


fileprivate struct CustomKeyboardTextfield: UIViewRepresentable {
	
	@Binding var input: String
	var keyboardHeight: CGFloat

	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.text = input
		textField.font = .systemFont(ofSize: 12)
		textField.delegate = context.coordinator
		textField.tintColor = .clear
		textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
		textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
		
		let AnimalKeyboardViewController = UIHostingController(
			rootView: EmojiKeyboardView(
				insertText: { text in
					textField.text = "\(textField.text ?? "")\(text)"
				},
				keyboardHeight: keyboardHeight
			))
		
		guard let animalKeyboardView = AnimalKeyboardViewController.view else { return textField }
		animalKeyboardView.translatesAutoresizingMaskIntoConstraints = false

		let inputView = UIInputView()
		inputView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: keyboardHeight))

		inputView.addSubview(animalKeyboardView)
		
		NSLayoutConstraint.activate([
			animalKeyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
			animalKeyboardView.widthAnchor.constraint(equalToConstant: inputView.frame.width)
		])

		textField.inputView = inputView
		return textField
	}

	func updateUIView(_ uiView: UITextField, context: Context) {}
	
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
