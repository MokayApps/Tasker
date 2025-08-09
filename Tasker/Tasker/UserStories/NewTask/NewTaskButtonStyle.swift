//
//  NewTaskBottomViewButton.swift
//  Tasker
//
//  Created by Andrei Kozlov on 10.08.2025.
//

import SwiftUI
import MokayUI

public struct NewTaskButtonStyle: ButtonStyle {
	
	public let isSelected: Bool
	
	private var color: Color {
		isSelected ? Color.accent.textPrimaryGreen : Color.accent.bgSecondary
	}
	
	public init(isSelected: Bool = false) {
		self.isSelected = isSelected
	}
	
	public func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.typography(.smallLabel)
			.frame(maxWidth: .infinity)
			.padding(.top, .x1)
			.padding(.bottom, .x05)
			.background(color, in: RoundedRectangle(cornerRadius: 17))
			.opacity(configuration.isPressed ? 0.5 : 1.0)
	}
}

extension ButtonStyle where Self == NewTaskButtonStyle {
	public static func newTask(isSelected: Bool = false) -> Self { Self(isSelected: isSelected) }
}
