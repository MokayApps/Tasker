//
//  NewTaskCategoryView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 17.08.2025.
//

import SwiftUI
import MokayUI

struct NewTaskCategoryView: View {
	
	private var columns: [GridItem] = [
		GridItem(.flexible(minimum: 60, maximum: 600), spacing: .x1, alignment: .center),
		GridItem(.flexible(minimum: 60, maximum: 600), spacing: .x1, alignment: .center)
	]
	
	@StateObject private var viewModel = NewTaskCategoryViewModel()
		
    var body: some View {
        ScrollView {
			LazyVGrid(
				columns: columns,
				alignment: .center,
				spacing: .x1,
				pinnedViews: []
			) {
				ForEach(viewModel.categories) { category in
					Button {
						print("Tap on category: \(category.name)")
					} label: {
						VStack(spacing: .x1) {
							Text(category.icon)
							
							Text(category.name)
								.typography(.caption)
								.foregroundColor(.textPrimary)
						}
						.frame(maxWidth: .infinity)
						.padding(.vertical, .x05)
						.background(Color.secondaryBlue, in: RoundedRectangle(cornerRadius: .r2))
						.overlay {
							RoundedRectangle(cornerRadius: .r2)
								.stroke(Color.accentBlue, lineWidth: 1.0)
						}
					}
				}
			}
			.padding(.x2)
		}
    }
}

#Preview {
    NewTaskCategoryView()
}
