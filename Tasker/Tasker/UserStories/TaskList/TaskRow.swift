//
//  TaskRow.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import MokayUI
import SwiftUI

struct TaskRow: View {
    
    @StateObject var viewModel: TaskRowViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: .x1) {
            Image(systemName: viewModel.isCompleted ? "checkmark.square.fill" : "square")
                .frame(width: 24, height: 24)
            
            Text(viewModel.title)
                .typography(.mediumLabel)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.x2)
		.background(
			viewModel.isCompleted ? Color.secondaryGreen :  .secondaryRed,
			in: RoundedRectangle(cornerRadius: .r2)
		)
		.contentShape(RoundedRectangle(cornerRadius: .r2))
        .onTapGesture {
            viewModel.toggleCompletion()
        }
    }
}
