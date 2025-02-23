//
//  Color+Extensions.swift
//  Tasker
//
//  Created by Єгор Привалов on 02.02.2025.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
	convenience init(
		light lightModeColor: @escaping @autoclosure () -> UIColor,
		dark darkModeColor: @escaping @autoclosure () -> UIColor
	) {
		self.init { traitCollection in
			switch traitCollection.userInterfaceStyle {
			case .light:
				return lightModeColor()
			case .dark:
				return darkModeColor()
			case .unspecified:
				return lightModeColor()
			@unknown default:
				return lightModeColor()
			}
		}
	}
}


extension Color {
	init(
		light lightModeColor: @escaping @autoclosure () -> Color,
		dark darkModeColor: @escaping @autoclosure () -> Color
	) {
		self.init(UIColor(
			light: UIColor(lightModeColor()),
			dark: UIColor(darkModeColor())
		))
	}
}

extension UIColor {
	public convenience init(_ rgbValue: UInt,_ alpha: CGFloat = 1.0) {
		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(alpha)
		)
	}
}

extension Color {
	init(_ hex: UInt, alpha: Double = 1) {
		self.init(
			.sRGB,
			red: Double((hex >> 16) & 0xff) / 255,
			green: Double((hex >> 08) & 0xff) / 255,
			blue: Double((hex >> 00) & 0xff) / 255,
			opacity: alpha
		)
	}
}
