//
//  NewTaskHeaderView.swift
//  Tasker
//
//  Created by Єгор Привалов on 10.04.2025.
//

import SwiftUI
import MokayUI

struct NewTaskHeaderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack(spacing: .zero) {
                ZStack {
                    Text("New Task")
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
            .padding([.horizontal, .vertical], .x2)
            Spacer()
        }
    }
} 
