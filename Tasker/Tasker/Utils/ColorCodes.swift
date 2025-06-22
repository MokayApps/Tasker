//
//  ColorCodes.swift
//  Tasker
//
//  Created by Єгор Привалов on 02.02.2025.
//

import Foundation
import SwiftUI

struct ColorCodes {
	static let primary: UInt = 0x0D0D0D
	static let bgSecondary: UInt = 0xF2F2F2
	static let secondaryTransparent: UInt = 0x000000
	static let textSecondary: UInt = 0x999999
	static let textPrimaryGreen: UInt = 0x23A947
}

extension Color {
	static let accent = Accent()
	
	static var random: Color {
		return Color(red: .random(in: 0..<1), green: .random(in: 0..<1), blue: .random(in: 0..<1))
	}
	
	struct Accent {
		let primary = Color(light: Color(ColorCodes.primary), dark: Color(ColorCodes.primary))
		let bgSecondary = Color(light: Color(ColorCodes.bgSecondary), dark: Color(ColorCodes.bgSecondary))
		let secondaryTransparent = Color(light: Color(ColorCodes.secondaryTransparent).opacity(0.35), dark: Color(ColorCodes.secondaryTransparent).opacity(0.35))
		let textSecondary = Color(light: Color(ColorCodes.textSecondary), dark: Color(ColorCodes.textSecondary))
		let textPrimaryGreen = Color(light: Color(ColorCodes.textPrimaryGreen), dark: Color(ColorCodes.textPrimaryGreen))
	}
}
