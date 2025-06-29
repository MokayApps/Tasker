//
//  NewTaskCreateButtonView.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import SwiftUI
import MokayUI

struct NewTaskCreateButtonView: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text("Create")
                    .typography(.mediumLabel)
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                Image(.done)
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
            }
        }
        .buttonStyle(.primaryMedium)
        .backgroundStyle(Color.green)
        .padding(.x2)
    }
} 
