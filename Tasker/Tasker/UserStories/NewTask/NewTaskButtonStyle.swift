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
	
	public init(isSelected: Bool = false) {
		self.isSelected = isSelected
	}
	
	public func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.typography(.smallLabel)
			.frame(maxWidth: .infinity)
			.padding(.top, .x1)
			.padding(.bottom, .x05)
			.background(Color.accent.bgSecondary, in: RoundedRectangle(cornerRadius: 17))
			.opacity(configuration.isPressed ? 0.5 : 1.0)
			.overlay {
				RoundedRectangle(cornerRadius: 17)
					.stroke(isSelected ? Color.accentGreen : .clear, lineWidth: 1.0)
			}
	}
}

extension ButtonStyle where Self == NewTaskButtonStyle {
	public static func newTask(isSelected: Bool = false) -> Self { Self(isSelected: isSelected) }
}
