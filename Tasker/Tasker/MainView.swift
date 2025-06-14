//
//  MainView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import SwiftUI
import SwiftData
import MokayDI

struct MainView: View {
    
    var body: some View {
        RouterView<TaskListView>(
            container: .main,
            router: Router(container: .main)
        )
        .backgroundStyle(.gray)
    }
    
}

#Preview {
    MainView()
}
