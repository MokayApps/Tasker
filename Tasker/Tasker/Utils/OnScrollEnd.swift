//
//  OnScrollEnd.swift
//  Tasker
//
//  Created by Єгор Привалов on 22.06.2025.
//

import SwiftUI

struct OnScrollEnd: ScrollTargetBehavior {
	var onEnd: @Sendable (CGFloat) -> ()
	
	func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
		let dy = context.velocity.dy
		let callback = onEnd
		DispatchQueue.main.async {
			callback(dy)
		}
	}
}
