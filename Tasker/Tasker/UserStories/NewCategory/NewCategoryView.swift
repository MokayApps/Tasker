//
//  NewCategoryView.swift
//  Tasker
//
//  Created by Roman Apanasevich on 02.02.2025.
//

import SwiftUI
import MokayUI
import MCEmojiPicker

struct NewCategoryView: View {
	
	@Environment(Router.self) var router
	@StateObject private var viewModel = NewCategoryViewModel()
	@FocusState private var isFocused: Bool
	
	// TODO: Поменять цвет
	private let colors: [Color] = [.green, .yellow, .orange, .red, .pink, .purple, .blue, .teal, .gray, .brown, .cyan, .mint, .indigo, .black]
	
	private let columns = Array(repeating: GridItem(.flexible(), spacing: .x2), count: 7)
	
	var body: some View {
		VStack {
			Spacer()
				.frame(height: .x2)
			
			headerView()
				.frame(height: 40)
				.padding(.horizontal, .x2)
				.padding(.bottom, .x2)
			
			HStack(spacing: .x2) {
				
				Button(viewModel.emoji) {
					viewModel.isPresentedEmoji.toggle()
				}.emojiPicker(
					isPresented: $viewModel.isPresentedEmoji,
					selectedEmoji: $viewModel.emoji
				)
				.typography(.h3)
				.padding(18.5)
				.frame(width: 63, height: 63)
				.background {
					RoundedRectangle(cornerRadius: .x3)
					// TODO: Пофиксить цвет
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
			
			shareButton()
				.frame(height: 56)
				.background {
					RoundedRectangle(cornerRadius: 17)
					// TODO: Поменять цвет
						.foregroundStyle(Color.green)
				}
				.padding(.horizontal, .x2)
				.padding(.vertical, .x2)
			
		}
		.contentShape(Rectangle())
		.onTapGesture {
			isFocused = false
		}
		.onAppear {
			let range = 0x1F601...0x1F64F
			let randomEmojiCodePoint = range.randomElement() ?? 0x1F60D
			let emoji = UnicodeScalar(randomEmojiCodePoint)?.description ?? "🍑"
			self.viewModel.emoji = emoji
			
			DispatchQueue.main.async {
				self.viewModel.selectedColor = colors.randomElement()
			}
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
					router.dismiss()
				} label: {
					Image(.close)
						.padding(8)
						.foregroundStyle(.black)
						.background {
							RoundedRectangle(cornerRadius: 17, style: .circular)
							// TODO: Пофиксить цвет
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
